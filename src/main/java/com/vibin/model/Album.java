package com.vibin.model;

import java.util.Date;

public class Album {
    private int albumId;
    private String albumName;
    private String artist;
    private Date releaseDate;
    private String genre;

    // Constructors
    public Album() {}

    public Album(int albumId, String albumName, String artist, Date releaseDate, String genre) {
        this.albumId = albumId;
        this.albumName = albumName;
        this.artist = artist;
        this.releaseDate = releaseDate;
        this.genre = genre;
    }

    // Getters and Setters
    public int getAlbumId() {
        return albumId;
    }

    public void setAlbumId(int albumId) {
        this.albumId = albumId;
    }

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }
}
