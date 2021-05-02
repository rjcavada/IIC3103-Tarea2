require "base64"
class ArtistsController < ApplicationController
    def index
        @artists = Artist.all;
        artists = []
        for @artist in @artists
            h1 = @artist.as_json(only: [:id, :name, :age, :tracks, :self])
            h2 = {"albums" => @artist.albums_url}
            h1 = h1.merge(h2)
            artists << h1
        end
        render json: artists, status: 200
    end

    def show
        @artist = Artist.find_by(id: params[:id])
        if @artist
            h1 = @artist.as_json(only: [:id, :name, :age, :tracks, :self])
            h2 = {"albums" => @artist.albums_url}
            h1 = h1.merge(h2)
            render json: h1
        else 
            render json: @artist, status: 404
        end
    end

    def show_albums
        albums = []
        if Artist.exists?(params[:id])
            @artist = Artist.find(params[:id])
        else
            @artist = nil
        end
        if @artist
            @albums = @artist.albums
            for @album in @albums
                h1 = @album.as_json(only: [:id, :artist_id, :name, :genre, :self])
                h2 = {"artist" => @album.artist_url, "tracks" => @album.tracks_url}
                h1 = h1.merge(h2)
                albums << h1
            end
            render json: albums
        else 
            render json: @artist, status: 404
        end
    end

    def show_tracks
        @artist_tracks = []
        tracks = []
        if Artist.exists?(params[:id])
            @artist = Artist.find(params[:id])
        else
            @artist = nil
        end
        if @artist
            @albums = @artist.albums
            for @album in @albums
                if @album == []
                    @tracks = []
                else
                    @tracks = @album.tracks
                end
                @artist_tracks += @tracks
            end
            for @track in @artist_tracks
                h1 = @track.as_json(only: [:id, :album_id, :name, :duration, :times_played, :artist, :self])
                h2 = {"album" => @track.album_url}
                h1 = h1.merge(h2)
                tracks << h1
            end
            render json: tracks
        else 
            render json: @artist, status: 404
        end
    end

    def create
        permitted = params.require(:artist).permit(:name, :age)
        puts params
        if permitted[:name].instance_of? String and permitted[:age].instance_of? Integer
            id = Base64.encode64(permitted[:name])[0,22].gsub("\n",'')
            url =request.base_url + "/artists/" + id
            @artist = Artist.new({
                id: id,
                name: permitted[:name],
                age: permitted[:age],
                albums_url: url + "/albums",
                tracks: url + "/tracks",
                self: url
            }
            )
            if Artist.exists?(id)
                @artist = Artist.find(id)
                h1 = @artist.as_json(only: [:id, :name, :age, :tracks, :self])
                h2 = {"albums" => @artist.albums_url}
                h1 = h1.merge(h2)
                render json: h1, status: 409
            else
                @artist.save
                h1 = @artist.as_json(only: [:id, :name, :age, :tracks, :self])
                h2 = {"albums" => @artist.albums_url}
                h1 = h1.merge(h2)
                render json: h1, status: :created
            end
        else
            render json: nil, status: 400
        end
    end

    def destroy
        if Artist.exists?(params[:id])
            @artist = Artist.find(params[:id])
            @artist.destroy
            render json: nil, status: 204
        else
            render json: nil, status: 404
        end
    end

    def play
        @artist_tracks = []
        @artist = Artist.find_by(id: params[:id])
        if @artist
            @albums = @artist.albums
            for @album in @albums
                if @album == []
                    @tracks = []
                else
                    @tracks = @album.tracks
                end
                @artist_tracks += @tracks
            end
            for @track in @artist_tracks
                @times = @track.times_played
                @times += 1
                @track.update(times_played: @times)
            end
            render json: nil, status: 200
        else 
            render json: @artist, status: 404
        end
    end
end