class Song {
  final String name;
  final String url;
  final String duration;
  final String author;

  Song(this.name, this.url, this.duration, this.author);

  Song.fromJson(Map<String, dynamic> json)
      : name = json['songname'],
        url = json['songurl'],
        duration = json['duration'],
        author = json['author'];

  Map<String, dynamic> toJson() =>
      {
        'songname': name,
        'songurl': url,
        'duration': duration,
        'author': author,
      };
}

class Playlist {
  final String name;
  final Set<Song> songs;

  Playlist(this.name, this.songs);

  Playlist.fromJson(Map<String, dynamic> json)
      : name = json['playlistname'],
        songs = json['songs'];

  Map<String, dynamic> toJson() =>
      {
        'songname': name,
        'songs': songs.map((e) => e.toJson()).toList(),
      };
}
