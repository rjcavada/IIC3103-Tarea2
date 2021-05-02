require "base64"
class TracksController < ApplicationController
    def index
        tracks = []
        @tracks = Track.all
        for @track in @tracks
            h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
            h2 = {"album" => @track.album_url}
            h1 = h1.merge(h2)
            tracks << h1
        end
        render json: tracks, status: 200
    end

    def show
        @track = Track.find_by(id: params[:id])
        if @track
            h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
            h2 = {"album" => @track.album_url}
            h1 = h1.merge(h2)
            render json: h1, status: 200
        else 
            render json: @track, status: 404
        end
    end

    def create
        permitted = params.require(:track).permit(:name, :duration)
        @album = Album.find_by(id: params[:id])
        if @album
            if permitted[:name].instance_of? String and permitted[:duration].instance_of? Float
                encodear = permitted[:name] + ":" + params[:id]
                id = Base64.encode64(encodear)[0,22].gsub("\n",'')
                url1 = request.base_url + "/albums/" + params[:id]
                url2 = request.base_url + "/artists/" + @album.artist.id
                url3 = request.base_url + "/tracks/" + id
                @track = Track.new({
                id: id,
                name: permitted[:name],
                duration: permitted[:duration],
                times_played: 0,
                artist: url2,
                album_url: url1,
                self: url3
            }
            )
                @track.album = @album
                if Track.exists?(id)
                    @track = Track.find(id)
                    h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
                    h2 = {"album" => @track.album_url}
                    h1 = h1.merge(h2)
                    render json: h1, status: 409
                else
                    @track.save
                    h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
                    h2 = {"album" => @track.album_url}
                    h1 = h1.merge(h2)
                    render json: h1, status: :created, location: @track
                end
            else
                render json: nil, status: 400
            end
        else 
            render json: @album, status: 422
        end
    end

    def destroy
        if Track.exists?(params[:id])
            @track = Track.find(params[:id])
            @track.destroy
            render json: nil, status: 204
        else
            render json: nil, status: 404
        end
    end

    def play
        @track = Track.find_by(id: params[:id])
        if @track
            @times = @track.times_played
            @times += 1
            @track.update(times_played: @times)
            render json: nil, status: 200
        else 
            render json: @track, status: 404
        end
    end
end