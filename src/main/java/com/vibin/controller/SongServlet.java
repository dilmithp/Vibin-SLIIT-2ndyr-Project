package com.vibin.controller;

import com.vibin.dao.SongDAO;
import com.vibin.model.Song;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/songs/*")
public class SongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SongDAO songDAO;

    public void init() {
        songDAO = new SongDAO();
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
                    insertSong(request, response);
                    break;
                case "/delete":
                    deleteSong(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateSong(request, response);
                    break;
                default:
                    listSongs(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listSongs(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Song> listSong = songDAO.selectAllSongs();
        request.setAttribute("listSong", listSong);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/song-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/song-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Song existingSong = songDAO.selectSong(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/song-form.jsp");
        request.setAttribute("song", existingSong);
        dispatcher.forward(request, response);
    }

    private void insertSong(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String songName = request.getParameter("songName");
        String lyricist = request.getParameter("lyricist");
        String singer = request.getParameter("singer");
        String musicDirector = request.getParameter("musicDirector");
        int albumId = Integer.parseInt(request.getParameter("albumId"));
        Song newSong = new Song(0, songName, lyricist, singer, musicDirector, albumId);
        songDAO.insertSong(newSong);
        response.sendRedirect("list");
    }

    private void updateSong(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String songName = request.getParameter("songName");
        String lyricist = request.getParameter("lyricist");
        String singer = request.getParameter("singer");
        String musicDirector = request.getParameter("musicDirector");
        int albumId = Integer.parseInt(request.getParameter("albumId"));

        Song song = new Song(id, songName, lyricist, singer, musicDirector, albumId);
        songDAO.updateSong(song);
        response.sendRedirect("list");
    }

    private void deleteSong(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        songDAO.deleteSong(id);
        response.sendRedirect("list");
    }
}
