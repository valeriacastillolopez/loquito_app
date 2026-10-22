package com.cattube.api;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "videos")
public class Video {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String username;
    private String tag;
    private String caption;
    private String hashtags;
    private String videoUrl;   // columna video_url
    private Integer likes;
    private Integer comments;
    private Integer shares;
    private LocalDateTime createdAt;   // columna created_at

    protected Video() {}

    public Integer getId() { return id; }
    public String getUsername() { return username; }
    public String getTag() { return tag; }
    public String getCaption() { return caption; }
    public String getHashtags() { return hashtags; }
    public String getVideoUrl() { return videoUrl; }
    public Integer getLikes() { return likes; }
    public Integer getComments() { return comments; }
    public Integer getShares() { return shares; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}