package com.vibin.artist;

public class ArtistLoginBean {
    private String username;
    private String password;
    private int artistId;
    private String artistName;
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public int getArtistId() {
        return artistId;
    }
    
    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }
    
    public String getArtistName() {
        return artistName;
    }
    
    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }
}
