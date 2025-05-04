package com.vibin.controller;

import com.vibin.dao.AlbumDAO;
import com.vibin.model.Album;
import com.vibin.model.Song;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/albums/*")
public class AlbumServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AlbumDAO albumDAO;

    public void init() {
        albumDAO = new AlbumDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertAlbum(request, response);
                    break;
                case "/delete":
                    deleteAlbum(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateAlbum(request, response);
                    break;
                case "/view":
                    viewAlbum(request, response);
                    break;
                default:
                    listAlbums(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listAlbums(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Album> listAlbum = albumDAO.selectAllAlbums();
        request.setAttribute("listAlbum", listAlbum);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/album-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/album-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Album existingAlbum = albumDAO.selectAlbum(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/album-form.jsp");
        request.setAttribute("album", existingAlbum);
        dispatcher.forward(request, response);
    }

    private void insertAlbum(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String albumName = request.getParameter("albumName");
        String artist = request.getParameter("artist");
        String genre = request.getParameter("genre");
        
        Date releaseDate = null;
        try {
            releaseDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("releaseDate"));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        Album newAlbum = new Album(0, albumName, artist, releaseDate, genre);
        albumDAO.insertAlbum(newAlbum);
        response.sendRedirect("list");
    }

    private void updateAlbum(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String albumName = request.getParameter("albumName");
        String artist = request.getParameter("artist");
        String genre = request.getParameter("genre");
        
        Date releaseDate = null;
        try {
            releaseDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("releaseDate"));
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Album album = new Album(id, albumName, artist, releaseDate, genre);
        albumDAO.updateAlbum(album);
        response.sendRedirect("list");
    }

    private void deleteAlbum(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        albumDAO.deleteAlbum(id);
        response.sendRedirect("list");
    }
    
    private void viewAlbum(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Album album = albumDAO.selectAlbum(id);
        List<Song> songs = albumDAO.getSongsByAlbumId(id);
        
        request.setAttribute("album", album);
        request.setAttribute("songs", songs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/album-detail.jsp");
        dispatcher.forward(request, response);
    }
}
