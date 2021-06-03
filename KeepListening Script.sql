    --************************************************* drop tables
    
    
    
    drop table usertemp cascade constraints;
    drop table artist cascade constraints;
    drop table maker cascade constraints;
    drop table media cascade constraints;
    drop table podcast cascade constraints;
    drop table audiobook cascade constraints;
    drop table livestream cascade constraints;
    drop table album cascade constraints;
    drop table song cascade constraints;
    drop table playlist cascade constraints;
    drop table genre cascade constraints;
    drop table cSong cascade constraints;
    drop table makeP cascade constraints;
    drop table follows_P cascade constraints;
    drop table cMedia cascade constraints;
    
    
    
    --************************************************* drop sequences
    
    drop sequence seq_user_id;
    drop sequence seq_media_id;
    drop sequence seq_playlist_id;
    drop sequence seq_csong_id;
    drop sequence seq_genre_num;
    
    
    --************************************************* create tables
    
    
    create table usertemp(
      id_user number(9,0),
      nickname varchar2(10) not null,
      email varchar2(30) not null,
      full_name varchar2(50) not null,
      password varchar2(10) not null,
      favourite_genre number(4,0),
      favourite_artist number(6,0)
    );
    
    create table artist(
      id_user number(9,0),
      id_genre number(4,0),
      stage_name varchar2(30) not null, 
      wiki varchar2(300)
    );
    
    create table maker(
      id_user number(9,0),
      tag_mkr varchar2(10)
    );
    
    create table media(
      id_media number(10,0), 
      duration_m varchar2(5) not null, 
      id_user number(9,0) not null, 
      description_m varchar2(50), 
      creation_date date not null, 
      views number(9,0)
    );
    
    create table podcast(
      id_media number(10,0),
      theme varchar2(20)
    );
    
    create table audiobook(
      id_media number(10,0),
      title varchar2(20) not null,
      narrator varchar2(20) not null,
      author varchar2(20) not null
    );
    
    create table liveStream(
      id_media number(10,0),
      schedule varchar2(20)
    );
    
    create table album(
      id_user number(9,0),
      album_name varchar2(30) not null,
      release_year number(4,0) not null,
      id_genre number(4,0),
      views number(9,0)
    );
    
    create table song(
      id_user number(9,0),
      album_name varchar2(30),
      song_name varchar2(20) not null,
      lyrics varchar2(100),
      id_genre number(4,0),
      views number(9,0)
    );
    
    create table playlist(
      id_playlist number(9,0),
      id_user number(9,0) not null,
      description_pl varchar2(30),
      creation_date date not null,
      views number(9,0)
    );
    
    create table genre(
      id_genre number(4,0),
      genre_name varchar2(20)
    );
    
    create table cSong(
      id_cSong number(9,0),
      id_playList number(9,0),
      id_user number(9,0),
      album_name varchar2(30),
      song_name varchar2(20),
      track_number number(2,0)
    );
    
    
    
    --************************************************* relations
    
    create table makeP(
      id_user number(9,0),
      id_playList number(9,0)
    );
    
    create table follows_P(
      id_user number(9,0),
      id_playList number(9,0)
    );
    
    create table cMedia(
      id_playList number(9,0),
      id_media number(10,0)
    );
    
    
    
    --************************************************* primary keys
    
    
    alter table usertemp add constraint pk_user primary key(id_user);
    alter table artist add constraint pk_artist primary key(id_user);
    alter table maker add constraint pk_maker primary key(id_user);
    alter table media add constraint pk_media primary key(id_media);
    alter table podcast add constraint pk_podcast primary key(id_media);
    alter table audiobook add constraint pk_audiobook primary key(id_media);
    alter table livestream add constraint pk_livestream primary key(id_media);
    alter table album add constraint pk_album primary key(id_user, album_name);
    alter table song add constraint pk_song primary key(id_user, album_name, song_name);
    alter table playlist add constraint pk_playlist primary key(id_playlist);
    alter table genre add constraint pk_genre primary key(id_genre);
    alter table makeP add constraint pk_makeP primary key(id_user, id_playList);
    alter table follows_P add constraint pk_follows primary key(id_user, id_playList);
    alter table cMedia add constraint pk_cMedia primary key(id_media, id_playlist);
    
    
    
    --************************************************* foreign keys
    
    
    
    alter table media add constraint fk_media foreign key (id_user) references maker(id_user);
    alter table album add constraint fk_album foreign key (id_user) references artist(id_user);
    alter table song add constraint fk_song foreign key (id_user, album_name) references album(id_user, album_name);
    --alter table song add constraint fk_song2 foreign key (id_user) references artist(id_user);
    alter table playlist add constraint fk_playlist foreign key (id_user) references usertemp(id_user);
    alter table makeP add constraint fk_makePU foreign key (id_user) references usertemp(id_user);
    alter table makeP add constraint fk_makePP foreign key (id_playList) references playlist(id_playlist);
    alter table follows_P add constraint fk_followsU foreign key (id_user) references usertemp(id_user);
    alter table follows_P add constraint fk_followsP foreign key (id_playlist) references playlist(id_playlist);
    alter table cMedia add constraint fk_cMediaM foreign key (id_media) references media(id_media);
    alter table cMedia add constraint fk_cMediaP foreign key (id_playlist) references playlist(id_playlist);
    
    
    
    --************************************************* unique
    
    
    
    alter table genre add constraint un_genre unique(genre_name);
    
    
    
    --************************************************* assertions
    
    
    
    --alter table media add constraint disjoint_media check
    -- (not exists ((select id_media from podcast) intersect (select id_media from audiobook)  intersect (select id_media from livestream)));
    
    
    
    --************************************************* sequences
    
    
    
    /*
        Sequence for User id
    */
    create sequence seq_user_id
    start with 1
    increment by 1;
    /*
        Sequence for Media id
    */
    create sequence seq_media_id
    start with 1
    increment by 1;
    /*
        Sequence for Playlist id
    */
    create sequence seq_playlist_id
    start with 1
    increment by 1;
    /*
        Sequence for cSong id
    */
    create sequence seq_csong_id
    start with 1
    increment by 1;
    
    create sequence seq_genre_num
    start with 1
    increment by 1;
    
    
    --************************************************* views
    
    
    
    create or replace view user_listens_to as
        select id_user, song_name
        from
            (select id_user, id_playList
            from follows_p 
            union all 
            select id_user, id_playList
            from MakeP)
        natural inner join
            (select id_playList, song_name
            from cSong);
    /	
    
    
    create or replace view user_playlists as
        select id_user, id_playlist
        from follows_p 
        union all
        select id_user, id_playlist
        from MakeP;
    
    /
    create or replace view song_searchables as
        (select song_name, stage_name, album_name, genre_name
        from 
        (artist natural inner join album)
    natural inner join
        (album natural inner join song)
    natural inner join
        (song natural inner join genre));
    
    /
    create or replace view media_in_playlist as
        select id_media
        from media 
        natural join cMedia;
    /
    create or replace view makers_and_media as
        (select tag_mkr, id_media
        from media natural join maker);
    /	
    
    
    --************************************************* triggers
    
    
    create or replace TRIGGER User_Num
        BEFORE INSERT ON UserTemp
        REFERENCING NEW AS NROW
        FOR EACH ROW
        DECLARE
            num_user number;
    BEGIN
        SELECT seq_user_id.nextval
        INTO num_user
        FROM dual;
        NROW.id_User := num_user;
    END;
    /
    create or replace TRIGGER Genre_Num
        BEFORE INSERT ON Genre
        REFERENCING NEW AS NROW
        FOR EACH ROW
        DECLARE
            num_genre number;
    BEGIN
        SELECT seq_genre_num.nextval
        INTO num_genre
        FROM dual;
        NROW.id_genre := num_genre;
    END;
    
    /
    create or replace trigger trg_check_dates_Trigger
     before insert or update on Media
     REFERENCING NEW AS NROW
     for each row 
    begin 
        if( NROW.creation_date <= SYSDATE ) 
        then
            RAISE_APPLICATION_ERROR( -20001,'Invalid Creation Date: Date cant be greater than the current date');
        end if;
    
    end;
    /
    
     create or replace trigger Podcast_Create_Trigger
     before insert on Podcast
     REFERENCING NEW AS NROW
    for each row
     begin 
        if( NROW.creation_date > SYSDATE )
        then 
            RAISE_APPLICATION_ERROR( -20001, 'Invalid Date:
            Creation date cannot be greater than the current date.');
        else    
            insert into Media values (NROW.id_media, NROW.duration, NROW.creation_date , NROW.description, NROW.views);
            insert into Podcast values (NROW.id_media, NROW.theme);
        end if;    
     end;
     /
     
     create or replace trigger AudioBook_Create_Trigger
     before insert on AudioBook
     REFERENCING NEW AS NROW
     for each row
     begin 
        if( new.creation_date > SYSDATE )
        then 
            RAISE_APPLICATION_ERROR( -20001, 'Invalid Date: Creation date cannot be greater than the current date.');
     insert into Media values (NROW.id_media, NROW.duration, NROW.creation_date , NROW.description, NROW.views);
     insert into AudioBook values (NROW.id_media, NROW.title, NROW.narrator, NROW.author);
        end if;
     end;
     /
     
     create or replace trigger LiveStream_Create_Trigger
     before insert on LiveStream
     REFERENCING NEW AS NROW
     for each row
     begin 
        if( NROW.creation_date > SYSDATE )
        then 
            RAISE_APPLICATION_ERROR( -20001, 'Invalid Date: Creation date cannot be greater than the current date.');
            insert into Media values (NROW.id_media, NROW.duration, NROW.creation_date , NROW.description, NROW.views);
            insert into LiveStream values (NROW.id_media, NROW.schedule);
        end if;    
     end;
    /
    
    create or replace trigger order_playlist_Trigger
        before delete on cSong
        referencing old as orow new as nrow
        for each row
    begin
        if(row.order < orow.order)
        then
            update cSong
            set nrow.order = orow.order - 1;
        end if;    
    end order_playlist;
    /
    