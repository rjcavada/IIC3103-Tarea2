require "base64"
class AlbumsController < ApplicationController
    def index
        albums = []
        @albums = Album.all
        for @album in @albums
            h1 = @album.as_json(only: [:id, :artist_id, :name, :genre, :self])
            h2 = {"artist" => @album.artist_url, "tracks" => @album.tracks_url}
            h1 = h1.merge(h2)
            albums << h1
        end
        render json: albums, status: 200
    end
    
    def show
        @album = Album.find_by(id: params[:id])
        if @album
            h1 = @album.as_json(only: [:id, :artist_id, :name, :genre, :self])
            h2 = {"artist" => @album.artist_url, "tracks" => @album.tracks_url}
            h1 = h1.merge(h2)
            render json: h1, status: 200
        else 
            render json: @album, status: 404
        end
    end

    def create
        permitted = params.require(:album).permit(:name, :genre)
        @artist = Artist.find_by(id: params[:id])
        if @artist
            if permitted[:name].instance_of? String and permitted[:genre].instance_of? String
                encodear = permitted[:name] + ":" + params[:id]
                album_id = Base64.encode64(encodear)[0,22].gsub("\n",'')
                url1 = request.base_url + "/artists/" + params[:id]
                url2 = request.base_url + "/albums/" + album_id
                @album = Album.new({
                id: album_id,
                name: permitted[:name],
                genre: permitted[:genre],
                artist_url: url1,
                tracks_url: url2 + "/tracks",
                self: url2
            }
            )
                @album.artist = @artist
                if Album.exists?(album_id)
                    @album = Album.find(album_id)
                    h1 = @album.as_json(only: [:id, :artist_id, :name, :genre, :self])
                    h2 = {"artist" => @album.artist_url, "tracks" => @album.tracks_url}
                    h1 = h1.merge(h2)
                    render json: h1, status: 409
                else
                    @album.save
                    h1 = @album.as_json(only: [:id, :artist_id, :name, :genre, :self])
                    h2 = {"artist" => @album.artist_url, "tracks" => @album.tracks_url}
                    h1 = h1.merge(h2)
                    render json: h1, status: :created
                end
            else
                render json: nil, status: 400
            end
        else 
            render json: @artist, status: 422
        end
    end

    def show_tracks
        tracks = []
        @album = Album.find_by(id: params[:id])
        if @album
            @tracks = @album.tracks
            for @track in @tracks
                h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
                h2 = {"album" => @track.album_url}
                h1 = h1.merge(h2)
                tracks << h1
            end
            render json: tracks, status: 200
        else 
            render json: @album, status: 404
        end
    end

    def destroy
        if Album.exists?(params[:id])
            @album = Album.find(params[:id])
            @album.destroy
            render json: nil, status: 204
        else
            render json: nil, status: 404
        end
    end

    def play
        @album = Album.find_by(id: params[:id])
        if @album
            @tracks = @album.tracks
            for @track in @tracks
                @times = @track.times_played
                @times += 1
                @track.update(times_played: @times)
            end
            render json: nil, status: 200
        else 
            render json: @album, status: 404
        end
    end
end
