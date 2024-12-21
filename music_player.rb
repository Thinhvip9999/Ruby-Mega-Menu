require 'rubygems'
require 'gosu'
require './input_functions.rb'
require './album_functions.rb'

Music_WIN_HEIGHT = 1300
Music_WIN_WIDTH = 2000

module ZOrder
    Music_BACKGROUND, Music_HOVER, Music_MIDDLE, Music_TOP = *0..3
end

class MenuMap
    attr_accessor :width, :height, :button, :albumborder, :volume, :screen, :display_mode, :exit_button, :favor, :ai
end

class Button
    attr_accessor :x, :y, :image
end

class Exit
    attr_accessor :x, :y, :image
end

class AlbumBorder
    attr_accessor :x, :y, :image
end

class DisplayMode
    attr_accessor :x, :y, :image
end

class Volume
    attr_accessor :x, :y, :image
end

class Favor
    attr_accessor :x, :y, :image
end

class Screen
    attr_accessor :x, :y, :image
end

class AI
    attr_accessor :x, :y, :image
end

class MyMusicPlayerWindow < Gosu::Window
    def initialize()
        #main setup
        super(Music_WIN_WIDTH,Music_WIN_HEIGHT,false)
        self.caption = "Music Player"

        @x_coordinate_of_ai_button = Array.new()
        @y_coordinate_of_ai_button = Array.new()

        @x_coordinate_of_exit_button = Array.new()
        @y_coordinate_of_exit_button = Array.new()

        @x_coordinate_of_display_mode = Array.new()
        @y_coordinate_of_display_mode = Array.new()

        @x_coordinate_of_buttons = Array.new()
        @y_coordinate_of_buttons = Array.new()

        @x_coordinate_of_albumsborder = Array.new()
        @y_coordinate_of_albumsborder = Array.new()

        @x_coordinate_of_volume = Array.new()
        @y_coordinate_of_volume = Array.new()

        @x_coordinate_of_favor = Array.new()
        @y_coordinate_of_favor = Array.new()

        @x_coordinate_of_screen = Array.new()
        @y_coordinate_of_screen = Array.new()

        @main_background = Gosu::Image.new("media/music_player_main_back_ground.jpg")
        #@side_background = Gosu::Image.new("media/music_player_side_back_ground.jpg")
        @track_display = Gosu::Image.new("media/track_display.png")
        @track1 = Gosu::Image.new("media/Track1.png")
        @track2 = Gosu::Image.new("media/Track2.png")
        @track3 = Gosu::Image.new("media/Track3.png")
        @menu_map = setup_menu_map("media/music_player_map.txt")
        @track_open = [false,false,false,false]
        @file_has_loaded = 0
        @albums = Array.new()
        #avoid reloading a file
        while @file_has_loaded != 1 do
            @albums, @file_has_loaded = read_in_albums()
        end
        @album = Album.new()
        i = 0
        @tracks = Array.new()
        @album_id, @current_song,@album = play_album(@albums)
        while i < @albums.length do
            @tracks << @albums[i].tracks
            i += 1
        end
        @location = @album.tracks[@current_song].location.chomp
        @song = Gosu::Song.new(@location)
        @song.pause
        @song.volume = 0.5
        #buttonhover
        @button_hover_mode1 = Gosu::Image.new("media/button_hover_mode1.png")
        #@button_hover_mode2 = Gosu::Image.new("media/button_hover_mode2.png")
        #buitruonglinh
        @buitruonglinh_album = Gosu::Image.new("media/BuiTruongLinh.jpg")
        #datg
        @datg_album = Gosu::Image.new("media/Dat G.jpg")
        #mr siro
        @mrsiro_album = Gosu::Image.new("media/Mr Siro.jpg")
        #phuong ly
        @phuongly_album = Gosu::Image.new("media/PhuongLy.jpg")
        #track image array
        @album1_images = Array.new()
        @album1_images << Gosu::Image.new("media/duongtoichoemve.jpg")
        @album1_images << Gosu::Image.new("media/Duchomaivesau.jpg")
        @album1_images << Gosu::Image.new("media/Yeunguoicouocmo.jpg")

        @album2_images = Array.new()
        @album2_images << Gosu::Image.new("media/Khovenucuoi.jpg")
        @album2_images << Gosu::Image.new("media/Buonkhongem.jpg")
        @album2_images << Gosu::Image.new("media/Ngaymaiemdimat.jpg")

        @album3_images = Array.new()
        @album3_images << Gosu::Image.new("media/Motbuocyeuvandamdau.jpg")
        @album3_images << Gosu::Image.new("media/Duoinhungconmua.jpg")
        @album3_images << Gosu::Image.new("media/Langnghenuocmat.jpg")

        @album4_images = Array.new()
        @album4_images << Gosu::Image.new("media/Mattroicuaem.jpg")
        @album4_images << Gosu::Image.new("media/MissingYou.jpg")
        @album4_images << Gosu::Image.new("media/AnhLaAi.jpg")

        @track_images = Array.new()
        @track_images << @album1_images
        @track_images << @album2_images
        @track_images << @album3_images
        @track_images << @album4_images
        @track_screen = @track_images[@album_id][@current_song]

        #volume level
        @volume_level = Array.new()
        @volume_level << Gosu::Image.new("media/volume 0.0.png")
        @volume_level << Gosu::Image.new("media/volume 0.1.png")
        @volume_level << Gosu::Image.new("media/volume 0.2.png")
        @volume_level << Gosu::Image.new("media/volume 0.3.png")
        @volume_level << Gosu::Image.new("media/volume 0.4.png")
        @volume_level << Gosu::Image.new("media/volume 0.5.png")
        @volume_level << Gosu::Image.new("media/volume 0.6.png")
        @volume_level << Gosu::Image.new("media/volume 0.7.png")
        @volume_level << Gosu::Image.new("media/volume 0.8.png")
        @volume_level << Gosu::Image.new("media/volume 0.9.png")
        @volume_level << Gosu::Image.new("media/volume 1.0.png")
        @current_volume = (@song.volume*10).to_i
        @volume_display = @volume_level[@current_volume]

        #auto skip song
        @tracks_time = [[266,213,296],[334,384,241,],[299,312,339],[249,252,281]]
        @turn_on_off_auto = false

        #display mode initialise
        @display_mode = 0
        @display_mode_images = Array.new()
        @display_mode_images << Gosu::Image.new("media/Display_mode1.png")
        @display_mode_images << Gosu::Image.new("media/Display_mode4.png")
        @display_mode_show = @display_mode_images[@display_mode]

        #favor initialise
        @favor_images = Array.new()
        @favor_images << Gosu::Image.new("media/favor_no.png")
        @favor_images << Gosu::Image.new("media/favor_yes.png")
        @favor_drawing = @favor_images[0]
        @favor_list = Array.new()
        @favor_song_index = 0
        @favor_count = 0

        #ai initialise
        @ai_yes_no = false
        @ai_positive_feeling = true
        @ai_box = Gosu::Image.new("media/ai_display.png")
        @ai_message1 = Gosu::Image.new("media/AI_message1.png")
        @ai_change_mood_back_default = Gosu::Image.new("media/AI_mood_back_default.png")
        @ai_change_mood_next_default = Gosu::Image.new("media/AI_mood_next_default.png")
        @ai_change_mood_back_hover = Gosu::Image.new("media/AI_mood_back_hover.png")
        @ai_change_mood_next_hover = Gosu::Image.new("media/AI_mood_next_hover.png")

        #default choice
        @ai_set_choice1_default = Array.new()
        @ai_set_choice1_default << Gosu::Image.new("media/AI_happy_default.png")
        @ai_set_choice1_default << Gosu::Image.new("media/AI_serenity_default.png")
        @ai_set_choice1_default << Gosu::Image.new("media/AI_excited_default.png")

        @ai_choice_default = Array.new()
        @ai_choice_default << @ai_set_choice1_default

        #hover choice
        @ai_set_choice1_hover = Array.new()
        @ai_set_choice1_hover << Gosu::Image.new("media/AI_happy_hover.png")
        @ai_set_choice1_hover <<Gosu::Image.new("media/AI_serenity_hover.png")
        @ai_set_choice1_hover <<Gosu::Image.new("media/AI_excited_hover.png")

        @ai_choice_hover = Array.new()
        @ai_choice_hover << @ai_set_choice1_hover
    end

    def draw_favor(array_need_check)
        check = array_need_check[@album_id].tracks[@current_song].favor
        if check 
            @favor_drawing = @favor_images[1]
        else
            @favor_drawing = @favor_images[0]
        end
    end

    def setup_ai(nummber_of_ai, image, x, y)
        ai = AI.new()
        ai.x, ai.y = x, y
        @x_coordinate_of_ai_button[nummber_of_ai] = x
        @y_coordinate_of_ai_button[nummber_of_ai] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        ai.image = image 
        #Gosu::Image.new("media/button.png")
        #puts("here")
        return ai
    end

    def setup_favor(nummber_of_favor, image, x, y)
        favor = Favor.new()
        favor.x, favor.y = x, y
        @x_coordinate_of_favor[nummber_of_favor] = x
        @y_coordinate_of_favor[nummber_of_favor] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        favor.image = image 
        #Gosu::Image.new("media/button.png")
        return favor
    end

    def setup_exit_button(nummber_of_exit_button, image, x, y)
        exit_button = Exit.new()
        exit_button.x, exit_button.y = x, y
        @x_coordinate_of_exit_button[nummber_of_exit_button] = x
        @y_coordinate_of_exit_button[nummber_of_exit_button] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        exit_button.image = image 
        #Gosu::Image.new("media/button.png")
        return exit_button
    end

    def setup_display_mode(nummber_of_display_mode, image, x, y)
        display_mode = DisplayMode.new()
        display_mode.x, display_mode.y = x, y
        @x_coordinate_of_display_mode[nummber_of_display_mode] = x
        @y_coordinate_of_display_mode[nummber_of_display_mode] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        display_mode.image = image 
        #Gosu::Image.new("media/button.png")
        return display_mode
    end

    def setup_button(nummber_of_button, image, x, y)
        button = Button.new()
        button.x, button.y = x, y
        @x_coordinate_of_buttons[nummber_of_button] = x
        @y_coordinate_of_buttons[nummber_of_button] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        button.image = image 
        #Gosu::Image.new("media/button.png")
        return button
    end

    def setup_albumborder(number_of_albumborder, image, x, y)
        album_border = AlbumBorder.new()
        album_border.x, album_border.y = x, y
        @x_coordinate_of_albumsborder[number_of_albumborder] = x
        @y_coordinate_of_albumsborder[number_of_albumborder] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        album_border.image = image 
        #Gosu::Image.new("media/button.png")
        return album_border
    end

    def setup_volume(number_of_volume, image, x, y)
        volume = Volume.new()
        volume.x, volume.y = x, y
        @x_coordinate_of_volume[number_of_volume] = x
        @y_coordinate_of_volume[number_of_volume] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        volume.image = image 
        #Gosu::Image.new("media/button.png")
        return volume
    end

    def setup_screen(number_of_screen, image, x, y)
        screen = Screen.new()
        screen.x, screen.y = x, y
        @x_coordinate_of_screen[number_of_screen] = x
        @y_coordinate_of_screen[number_of_screen] = y
        #puts (nummber_of_button)
        #puts("button #{nummber_of_button}")
        #puts($x_coordinate_of_buttons[nummber_of_button])
        #puts($y_coordinate_of_buttons[nummber_of_button])
        screen.image = image 
        #Gosu::Image.new("media/button.png")
        return screen
    end

    def draw_function(function)
        function.image.draw(function.x, function.y, ZOrder::Music_TOP)
    end

    def setup_menu_map(filename)
        menu_map = MenuMap.new()
        #button array set up
        array_of_button_image = []
        array_of_button_image << Gosu::Image.new("media/music_player_random_song.png")
        array_of_button_image << Gosu::Image.new("media/music_player_back.png")
        array_of_button_image << Gosu::Image.new("media/music_player_pause.png")
        array_of_button_image << Gosu::Image.new("media/music_player_play.png")
        array_of_button_image << Gosu::Image.new("media/music_player_stop.png")
        array_of_button_image << Gosu::Image.new("media/music_player_next.png")
        array_of_button_image << Gosu::Image.new("media/music_player_repeat.png")
        menu_map.button = []

        #album border set up
        album_border_image = Gosu::Image.new("media/music_player_border.png")
        menu_map.albumborder = []

        #volume set up
        array_of_volume_image = []
        array_of_volume_image << Gosu::Image.new("media/music_player_volume_minus.png")
        array_of_volume_image << Gosu::Image.new("media/music_player_volume_plus.png")
        menu_map.volume = []

        #screen set up
        screen_image = Gosu::Image.new("media/trackborder.png")
        menu_map.screen = []

        #display_mode set up
        display_mode_image = Gosu::Image.new("media/display_mode.png")
        menu_map.display_mode = []

        #exit button set up
        exit_button_image = Gosu::Image.new("media/exit_button_for_music_player.png")
        menu_map.exit_button = []

        #favor set up
        favor_image = Gosu::Image.new("media/favor_yes.png")
        menu_map.favor = []

        #ai set up
        ai_image = Gosu::Image.new("media/AI button.png")
        menu_map.ai = []

        #count number of each element
        nummber_of_button = 0
        number_of_albumborder = 0
        number_of_volume = 0
        number_of_screen = 0
        nummber_of_display_mode = 0
        nummber_of_exit_button = 0
        number_of_favor = 0
        number_of_ai = 0

        #set up according to txt file
        lines = File.readlines(filename).map { |line| line.chomp }
        menu_map.height = lines.size
        menu_map.width = lines[0].size
        #puts(menu_map.height, menu_map.width)
        Array.new(menu_map.height) do |y|
            Array.new(menu_map.width) do |x|
                case lines[y][x,1]
                when "r"
                    menu_map.ai.push(setup_ai(number_of_ai,ai_image,x*100,y*100))
                    number_of_ai += 1
                when "f"
                    menu_map.favor.push(setup_favor(number_of_favor, favor_image, x*100, y*100))
                    number_of_favor += 1
                when "e"
                    menu_map.exit_button.push(setup_exit_button(nummber_of_exit_button, exit_button_image, x*100, y*100))
                    nummber_of_exit_button += 1
                when "d"
                    menu_map.display_mode.push(setup_display_mode(nummber_of_display_mode, display_mode_image, x*100, y*100))
                    nummber_of_display_mode += 1
                when "x"
                    button_image = array_of_button_image[nummber_of_button]
                    menu_map.button.push(setup_button(nummber_of_button, button_image, x*100, y*100))
                    nummber_of_button += 1
                when "a"
                    menu_map.albumborder.push(setup_albumborder(number_of_albumborder, album_border_image, x*100, y*100))
                    number_of_albumborder += 1
                when "v"
                    menu_map.volume.push(setup_volume(number_of_volume, array_of_volume_image[number_of_volume], x*100, y*100))
                    number_of_volume += 1
                when "s"
                    menu_map.screen.push(setup_screen(number_of_screen, screen_image, x*100, y*100))
                    number_of_screen += 1
                else
                    nil
                end
            end
        end
        menu_map
    end

    def draw_menu_map(menu_map)
        menu_map.button.each { |b| draw_function(b) }
        menu_map.albumborder.each { |b| draw_function(b) }
        menu_map.volume.each { |b| draw_function(b) }
        menu_map.screen.each { |b| draw_function(b) }
        menu_map.display_mode.each { |b| draw_function(b) }
        menu_map.exit_button.each { |b| draw_function(b) }
        menu_map.favor.each { |b| draw_function(b) }
        menu_map.ai.each {|b| draw_function(b)}
    end


    def needs_cursor?; true; end

    def mouse_over_button(mouse_x, mouse_y)
        #size
        button_width = 100
        button_height = 100
        album_width = 275
        album_height = 275
        volume_width = 100
        volume_height = 100
        #button area
        if ((mouse_y > @y_coordinate_of_buttons[0] and mouse_y < @y_coordinate_of_buttons[0] + button_height) and (mouse_x > @x_coordinate_of_buttons[0]))

            if (mouse_x > @x_coordinate_of_buttons[0] and mouse_x < @x_coordinate_of_buttons[0] + button_width)
                return "button1"

            elsif (mouse_x > @x_coordinate_of_buttons[1] and mouse_x < @x_coordinate_of_buttons[1] + button_width )
                return "button2"

            elsif (mouse_x > @x_coordinate_of_buttons[2] and mouse_x < @x_coordinate_of_buttons[2] + button_width)
                return "button3"

            elsif (mouse_x > @x_coordinate_of_buttons[3] and mouse_x < @x_coordinate_of_buttons[3] + button_width )
                return "button4"

            elsif (mouse_x > @x_coordinate_of_buttons[4] and mouse_x < @x_coordinate_of_buttons[4] + button_width )
                return "button5"

            elsif (mouse_x > @x_coordinate_of_buttons[5] and mouse_x < @x_coordinate_of_buttons[5] + button_width )
                return "button6"

            elsif (mouse_x > @x_coordinate_of_buttons[6] and mouse_x < @x_coordinate_of_buttons[6] + button_width)
                return "button7"
            end
        
        #volume area
        elsif ((mouse_y > @y_coordinate_of_volume[0] and mouse_y < @y_coordinate_of_volume[0] + volume_height) and (mouse_x > @x_coordinate_of_volume[0]))

            if (mouse_x > @x_coordinate_of_volume[0] and mouse_x < @x_coordinate_of_volume[0] + volume_width)
                return "volume1"

            elsif (mouse_x > @x_coordinate_of_volume[1] and mouse_x < @x_coordinate_of_volume[1] + volume_width )
                return "volume2"
            end

        #main area
        else
            if ((mouse_x > @x_coordinate_of_albumsborder[0] and mouse_x < @x_coordinate_of_albumsborder[0] + album_width) and  (mouse_y > @y_coordinate_of_albumsborder[0] and mouse_y < @y_coordinate_of_albumsborder[0] + album_height))
                return "album1"
            
            elsif ((mouse_x > @x_coordinate_of_albumsborder[1] and mouse_x < @x_coordinate_of_albumsborder[1] + album_width) and  (mouse_y > @y_coordinate_of_albumsborder[1] and mouse_y < @y_coordinate_of_albumsborder[1] + album_height))
                return "album2"

            elsif ((mouse_x > @x_coordinate_of_albumsborder[2] and mouse_x < @x_coordinate_of_albumsborder[2] + album_width) and  (mouse_y > @y_coordinate_of_albumsborder[2] and mouse_y < @y_coordinate_of_albumsborder[2] + album_height))
                return "album3"

            elsif ((mouse_x > @x_coordinate_of_albumsborder[3] and mouse_x < @x_coordinate_of_albumsborder[3] + album_width) and  (mouse_y > @y_coordinate_of_albumsborder[3] and mouse_y < @y_coordinate_of_albumsborder[3] + album_height))
                return "album4"
            end
        end
    end
    
    def mouse_over_button_for_track(mouse_x, mouse_y)
        track_add_width = 300
        track_add_height = 30
        distance_between_track = 100
        if (mouse_x > @x_coordinate_of_albumsborder[0] + track_add_width and mouse_x < @x_coordinate_of_albumsborder[0] + track_add_width + 200) and (mouse_y > @y_coordinate_of_albumsborder[0] and mouse_y < @y_coordinate_of_albumsborder[0] + 75 + distance_between_track*2)
            if (mouse_y > @y_coordinate_of_albumsborder[0] and mouse_y < @y_coordinate_of_albumsborder[0] + 75 )
                return "buitruonglinhtrack1"
            elsif (mouse_y > @y_coordinate_of_albumsborder[0] + distance_between_track and mouse_y < @y_coordinate_of_albumsborder[0] + 75 + distance_between_track)
                return "buitruonglinhtrack2"
            elsif (mouse_y > @y_coordinate_of_albumsborder[0] + distance_between_track*2 and mouse_y < @y_coordinate_of_albumsborder[0] + 75 + distance_between_track*2)
                return "buitruonglinhtrack3"
            end

        elsif (mouse_x > @x_coordinate_of_albumsborder[1] + track_add_width and mouse_x < @x_coordinate_of_albumsborder[1] + track_add_width + 200) and (mouse_y > @y_coordinate_of_albumsborder[1] and mouse_y < @y_coordinate_of_albumsborder[1] + 75 + distance_between_track*2)
            if (mouse_y > @y_coordinate_of_albumsborder[1] and mouse_y < @y_coordinate_of_albumsborder[1] + 75 )
                return "datgtrack1"
            elsif (mouse_y > @y_coordinate_of_albumsborder[1] + distance_between_track and mouse_y < @y_coordinate_of_albumsborder[1] + 75 + distance_between_track)
                return "datgtrack2"
            elsif (mouse_y > @y_coordinate_of_albumsborder[1] + distance_between_track*2 and mouse_y < @y_coordinate_of_albumsborder[1] + 75 + distance_between_track*2)
                #puts($x_coordinate_of_albumsborder[2])
                #puts($y_coordinate_of_albumsborder[2])
                return "datgtrack3"
            end

        elsif (mouse_x > @x_coordinate_of_albumsborder[2] + track_add_width and mouse_x < @x_coordinate_of_albumsborder[2] + track_add_width + 200) and (mouse_y > @y_coordinate_of_albumsborder[2] and mouse_y < @y_coordinate_of_albumsborder[2] + 75 + distance_between_track*2)
            if (mouse_y > @y_coordinate_of_albumsborder[2] and mouse_y < @y_coordinate_of_albumsborder[2] + 75 )
                #puts("im right")
                return "mrsirotrack1"
            elsif (mouse_y > @y_coordinate_of_albumsborder[2] + distance_between_track and mouse_y < @y_coordinate_of_albumsborder[2] + 75 + distance_between_track)
                return "mrsirotrack2"
            elsif (mouse_y > @y_coordinate_of_albumsborder[2] + distance_between_track*2 and mouse_y < @y_coordinate_of_albumsborder[2] + 75 + distance_between_track*2)
                #puts($x_coordinate_of_albumsborder[2])
                #puts($y_coordinate_of_albumsborder[2])
                return "mrsirotrack3"
            end
        elsif (mouse_x > @x_coordinate_of_albumsborder[3] + track_add_width and mouse_x < @x_coordinate_of_albumsborder[3] + track_add_width + 200) and (mouse_y > @y_coordinate_of_albumsborder[3] and mouse_y < @y_coordinate_of_albumsborder[3] + 75 + distance_between_track*2)
            if (mouse_y > @y_coordinate_of_albumsborder[3] and mouse_y < @y_coordinate_of_albumsborder[3] + 75 )
                #puts("im right")
                return "phuonglytrack1"
            elsif (mouse_y > @y_coordinate_of_albumsborder[3] + distance_between_track and mouse_y < @y_coordinate_of_albumsborder[3] + 75 + distance_between_track)
                return "phuonglytrack2"
            elsif (mouse_y > @y_coordinate_of_albumsborder[3] + distance_between_track*2 and mouse_y < @y_coordinate_of_albumsborder[3] + 75 + distance_between_track*2)
                #puts($x_coordinate_of_albumsborder[2])
                #puts($y_coordinate_of_albumsborder[2])
                return "phuonglytrack3"
            end
        end
    end

    def mouse_over_button_for_other_function(mouse_x, mouse_y)
        display_mode_width = 470
        display_mode_height = 170
        exit_button_width = 100
        exit_button_height = 100
        favor_width = 100
        favor_height = 100
        ai_width = 100
        ai_height = 100
        if (mouse_x > @x_coordinate_of_display_mode[0] and mouse_x < @x_coordinate_of_display_mode[0] + display_mode_width) and (mouse_y > @y_coordinate_of_display_mode[0] and mouse_y < @y_coordinate_of_display_mode[0] + display_mode_height)
            return "display_mode"
        elsif (mouse_x > @x_coordinate_of_exit_button[0] and mouse_x <@x_coordinate_of_exit_button[0] + exit_button_width) and (mouse_y > @y_coordinate_of_exit_button[0] and mouse_y < @y_coordinate_of_exit_button[0] + exit_button_height)
            return "exit_button"
        elsif (mouse_x > @x_coordinate_of_favor[0] and mouse_x <@x_coordinate_of_favor[0] + favor_width) and (mouse_y > @y_coordinate_of_favor[0] and mouse_y < @y_coordinate_of_favor[0] + favor_height)
            return "favor"
        elsif (mouse_x > @x_coordinate_of_ai_button[0] and mouse_x <@x_coordinate_of_ai_button[0] + ai_width) and (mouse_y > @y_coordinate_of_ai_button[0] and mouse_y < @y_coordinate_of_ai_button[0] + ai_height)
            return "ai"
        end
    end

    def mouse_over_button_in_ai(mouse_x, mouse_y)
        if @ai_positive_feeling
            distance_between_button_and_choice = 100
            distance_between_choice = 250
            if (mouse_y > @y_coordinate_of_ai_button[0]+125 and mouse_y < @y_coordinate_of_ai_button[0]+125+104) and @ai_yes_no
                if (mouse_x > @x_coordinate_of_ai_button[0] and mouse_x < @x_coordinate_of_ai_button[0]+74) 
                    return "back"
                    #puts("I am Thinh")
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice+214)
                    return "choice1"
                elsif ( mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice + 214)
                    return "choice2"
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2 and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2 + 214 )
                    return "choice3"
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2 and mouse_x < @x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2 +214)
                    return "next"
                end
            end
        else
            distance_between_button_and_choice = 100
            distance_between_choice = 250
            if (mouse_y > @y_coordinate_of_ai_button[0]+125 and mouse_y < @y_coordinate_of_ai_button[0]+125+104) and @ai_yes_no
                if (mouse_x > @x_coordinate_of_ai_button[0] and mouse_x < @x_coordinate_of_ai_button[0]+74) 
                    return "fback"
                    #puts("I am Thinh")
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice+214)
                    return "fchoice1"
                elsif ( mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice + 214)
                    return "fchoice2"
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2 and mouse_x < @x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2 + 214 )
                    return "fchoice3"
                elsif (mouse_x > @x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2 and mouse_x < @x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2 +214)
                    return "fnext"
                end
            end
        end
    end

    #toogle or draw button
    def toogle_or_draw_button(index)
        if @track_open[index]
            @track_open[index] = false
            #puts("i toogle")
        else
            @track_open[index] = true
            @track_open[index-1], @track_open[index-2], @track_open[index-3] = false,false,false
        end
    end

    def draw()
        #album fit
        album_add_width = 50
        album_add_height = 25
        button_add = 100
        album_add = 275
        track_add_width = 300
        track_sub_height = 50
        distance_between_track = 100
        #draw x,y coordinate
        #@info_font.draw("mouse_x: #{mouse_x}", 0, 740, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        #@info_font.draw("mouse_y: #{mouse_y}", 0, 720, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)

        #draw skelenton
        @main_background.draw(0,0,ZOrder::Music_BACKGROUND)
        #@side_background.draw(1272,0,ZOrder::MIDDLE)
        draw_menu_map(@menu_map)
        #puts($x_coordinate_of_albumsborder[0], $y_coordinate_of_albumsborder[0])
        @buitruonglinh_album.draw(@x_coordinate_of_albumsborder[0] + album_add_width, @y_coordinate_of_albumsborder[0] + album_add_height, ZOrder::Music_TOP)
        @datg_album.draw(@x_coordinate_of_albumsborder[1] + album_add_width, @y_coordinate_of_albumsborder[1] + album_add_height, ZOrder::Music_TOP)
        @mrsiro_album.draw(@x_coordinate_of_albumsborder[2] + album_add_width, @y_coordinate_of_albumsborder[2] + album_add_height, ZOrder::Music_TOP)
        @phuongly_album.draw(@x_coordinate_of_albumsborder[3] + album_add_width, @y_coordinate_of_albumsborder[3] + album_add_height, ZOrder::Music_TOP)

        
        #mouse over button
        case mouse_over_button(mouse_x, mouse_y)
        #button
        when "button1"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[0] , @y_coordinate_of_buttons[0] + button_add, ZOrder::Music_TOP)
        when "button2"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[1], @y_coordinate_of_buttons[1] + button_add, ZOrder::Music_TOP)
        when "button3"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[2], @y_coordinate_of_buttons[2] + button_add, ZOrder::Music_TOP)
        when "button4"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[3], @y_coordinate_of_buttons[3] + button_add, ZOrder::Music_TOP)
        when "button5"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[4], @y_coordinate_of_buttons[4] + button_add, ZOrder::Music_TOP)
        when "button6"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[5], @y_coordinate_of_buttons[5] + button_add, ZOrder::Music_TOP)
        when "button7"
            @button_hover_mode1.draw(@x_coordinate_of_buttons[6], @y_coordinate_of_buttons[6] + button_add, ZOrder::Music_TOP)

        #album
        when "album1"
            @button_hover_mode1.draw(@x_coordinate_of_albumsborder[0],@y_coordinate_of_albumsborder[0]+ album_add, ZOrder::Music_TOP)
        when "album2"
            @button_hover_mode1.draw(@x_coordinate_of_albumsborder[1],@y_coordinate_of_albumsborder[1]+ album_add, ZOrder::Music_TOP)
        when "album3"
            @button_hover_mode1.draw(@x_coordinate_of_albumsborder[2],@y_coordinate_of_albumsborder[2]+ album_add, ZOrder::Music_TOP)
        when "album4"
            @button_hover_mode1.draw(@x_coordinate_of_albumsborder[3],@y_coordinate_of_albumsborder[3]+ album_add, ZOrder::Music_TOP)

        #volume
        when "volume1"
            @button_hover_mode1.draw(@x_coordinate_of_volume[0],@y_coordinate_of_volume[0] + button_add, ZOrder::Music_TOP)
        when "volume2"
            @button_hover_mode1.draw(@x_coordinate_of_volume[1],@y_coordinate_of_volume[1] + button_add, ZOrder::Music_TOP)
        end

        #mouse_hover_track
        display_mode_width = 470
        display_mode_height = 170
        exit_button_width = 100
        exit_button_height = 100
        favor_width = 100
        favor_height = 100
        ai_width = 100
        ai_height = 100
        case mouse_over_button_for_other_function(mouse_x, mouse_y)
        when "display_mode"
            @button_hover_mode1.draw(@x_coordinate_of_display_mode[0], @y_coordinate_of_display_mode[0] + display_mode_height, ZOrder::Music_TOP)
        when "exit_button"
            @button_hover_mode1.draw(@x_coordinate_of_exit_button[0], @y_coordinate_of_exit_button[0] + exit_button_height, ZOrder::Music_TOP)
        when "favor"
            @button_hover_mode1.draw(@x_coordinate_of_favor[0], @y_coordinate_of_favor[0] + favor_height, ZOrder::Music_TOP)
        when "ai"
            @button_hover_mode1.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0] + ai_height, ZOrder::Music_TOP)
        end

        distance_between_button_and_choice = 100
        distance_between_choice = 250
        if @ai_positive_feeling
            case mouse_over_button_in_ai(mouse_x, mouse_y)
            when "back"
                @ai_change_mood_back_hover.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "choice1"
                @ai_choice_hover[0][0].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "choice2"
                @ai_choice_hover[0][1].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "choice3"
                @ai_choice_hover[0][2].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "next"
                @ai_change_mood_next_hover.draw(@x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            end
        else
            case mouse_over_button_in_ai(mouse_x, mouse_y)
            when "fback"
                @ai_change_mood_back_hover.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "fchoice1"
                @ai_choice_hover[0][0].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "fchoice2"
                @ai_choice_hover[0][1].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "fchoice3"
                @ai_choice_hover[0][2].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            when "fnext"
                @ai_change_mood_next_hover.draw(@x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_TOP)
            end
        end

        #track display
        if @track_open[0]
            @track_display.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0] - track_sub_height, ZOrder::Music_MIDDLE)
            @track1.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0], ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0] - track_sub_height + distance_between_track, ZOrder::Music_MIDDLE)
            @track2.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0] + distance_between_track, ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0] - track_sub_height + distance_between_track*2, ZOrder::Music_MIDDLE)
            @track3.draw(@x_coordinate_of_albumsborder[0] + track_add_width, @y_coordinate_of_albumsborder[0] + distance_between_track*2, ZOrder::Music_TOP)
        end
        if @track_open[1]
            @track_display.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1] - track_sub_height, ZOrder::Music_MIDDLE)
            @track1.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1], ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1] - track_sub_height + distance_between_track, ZOrder::Music_MIDDLE)
            @track2.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1] + distance_between_track, ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1] - track_sub_height + distance_between_track*2, ZOrder::Music_MIDDLE)
            @track3.draw(@x_coordinate_of_albumsborder[1] + track_add_width, @y_coordinate_of_albumsborder[1] + distance_between_track*2, ZOrder::Music_TOP)
        end
        if @track_open[2]
            @track_display.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2] - track_sub_height, ZOrder::Music_MIDDLE)
            @track1.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2], ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2] - track_sub_height + distance_between_track, ZOrder::Music_MIDDLE)
            @track2.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2] + distance_between_track, ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2] - track_sub_height + distance_between_track*2, ZOrder::Music_MIDDLE)
            @track3.draw(@x_coordinate_of_albumsborder[2] + track_add_width, @y_coordinate_of_albumsborder[2] + distance_between_track*2, ZOrder::Music_TOP)
        end
        if @track_open[3]
            @track_display.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3] - track_sub_height, ZOrder::Music_MIDDLE)
            @track1.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3], ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3] - track_sub_height + distance_between_track, ZOrder::Music_MIDDLE)
            @track2.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3] + distance_between_track, ZOrder::Music_TOP)
            @track_display.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3] - track_sub_height + distance_between_track*2, ZOrder::Music_MIDDLE)
            @track3.draw(@x_coordinate_of_albumsborder[3] + track_add_width, @y_coordinate_of_albumsborder[3] + distance_between_track*2, ZOrder::Music_TOP)
        end
        
        if @ai_yes_no
            distance_between_button_and_choice = 100
            distance_between_choice = 250
            @ai_box.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0]+12, ZOrder::Music_HOVER)
            @ai_message1.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0], ZOrder::Music_MIDDLE)
            @ai_change_mood_back_default.draw(@x_coordinate_of_ai_button[0], @y_coordinate_of_ai_button[0]+125, ZOrder::Music_MIDDLE)
            @ai_choice_default[0][0].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_MIDDLE)
            @ai_choice_default[0][1].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_MIDDLE)
            @ai_choice_default[0][2].draw(@x_coordinate_of_ai_button[0] + distance_between_button_and_choice + distance_between_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_MIDDLE)
            @ai_change_mood_next_default.draw(@x_coordinate_of_ai_button[0] + 125 + distance_between_choice*2 + distance_between_button_and_choice*2, @y_coordinate_of_ai_button[0]+125, ZOrder::Music_MIDDLE)
        end
        #music screen
        #puts($x_coordinate_of_screen[0])
        #puts($y_coordinate_of_screen[0])
        @track_screen.draw(@x_coordinate_of_screen[0]+100,@y_coordinate_of_screen[0]+35,ZOrder::Music_TOP)
        #volume display
        @volume_display.draw(@x_coordinate_of_volume[0] +125, @y_coordinate_of_volume[0], ZOrder::Music_TOP)
        #display mode letter
        @display_mode_show.draw(@x_coordinate_of_display_mode[0] + 50, @y_coordinate_of_display_mode[0], ZOrder::Music_TOP )
        #favor 
        @favor_drawing.draw(@x_coordinate_of_favor[0],@y_coordinate_of_favor[0], ZOrder::Music_TOP)
    end

    def button_down(id)
        
        #AI brain set up
        if @ai_yes_no
            if @ai_positive_feeling
                #set up all the choice
                case id 
                when Gosu::MsLeft
                    begin
                        case mouse_over_button_in_ai(mouse_x,mouse_y)
                        when "back"
                            @ai_positive_feeling = false
                            @ai_choice_default[0][0] = Gosu::Image.new("media/AI_sad_default.png")
                            @ai_choice_default[0][1] = Gosu::Image.new("media/AI_tired_default.png")
                            @ai_choice_default[0][2] = Gosu::Image.new("media/AI_angry_default.png")

                            @ai_choice_hover[0][0] = Gosu::Image.new("media/AI_sad_hover.png")
                            @ai_choice_hover[0][1] = Gosu::Image.new("media/AI_tired_hover.png")
                            @ai_choice_hover[0][2] = Gosu::Image.new("media/AI_angry_hover.png")
                            @song.stop
                        when "choice1" #happy
                            @ai_message1 = Gosu::Image.new("media/AI_happy_message.png")
                            @current_song = 0
                            @album_id = 3
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "choice2" #serenity
                            @ai_message1 = Gosu::Image.new("media/AI_serenity_message.png")
                            @current_song = 2
                            @album_id = 3
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "choice3" #excited
                            @ai_message1 = Gosu::Image.new("media/AI_excited_message.png")
                            @current_song = 2
                            @album_id = 0
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "next"
                            @ai_positive_feeling = false
                            @ai_choice_default[0][0] = Gosu::Image.new("media/AI_sad_default.png")
                            @ai_choice_default[0][1] = Gosu::Image.new("media/AI_tired_default.png")
                            @ai_choice_default[0][2] = Gosu::Image.new("media/AI_angry_default.png")

                            @ai_choice_hover[0][0] = Gosu::Image.new("media/AI_sad_hover.png")
                            @ai_choice_hover[0][1] = Gosu::Image.new("media/AI_tired_hover.png")
                            @ai_choice_hover[0][2] = Gosu::Image.new("media/AI_angry_hover.png")
                            @song.stop
                        end
                    end
                end
            else
                #set up all the choice
                case id 
                when Gosu::MsLeft
                    begin
                        case mouse_over_button_in_ai(mouse_x,mouse_y)
                        when "fback"
                            @ai_positive_feeling = true
                            @song.stop
                            @ai_choice_default[0][0] = Gosu::Image.new("media/AI_happy_default.png")
                            @ai_choice_default[0][1] = Gosu::Image.new("media/AI_serenity_default.png")
                            @ai_choice_default[0][2] = Gosu::Image.new("media/AI_excited_default.png")

                            @ai_choice_hover[0][0] = Gosu::Image.new("media/AI_happy_hover.png")
                            @ai_choice_hover[0][1] = Gosu::Image.new("media/AI_serenity_hover.png")
                            @ai_choice_hover[0][2] = Gosu::Image.new("media/AI_excited_hover.png")
                        when "fchoice1" #sad
                            @ai_message1 = Gosu::Image.new("media/AI_sad_message.png")
                            @current_song = 0
                            @album_id = 2
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "fchoice2" #tired
                            @ai_message1 = Gosu::Image.new("media/AI_tired_message.png")
                            @current_song = 1
                            @album_id = 1
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "fchoice3" #angry
                            @ai_message1 = Gosu::Image.new("media/AI_angry_message.png")
                            @current_song = 2
                            @album_id = 2
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album, @album_id)
                        when "fnext"
                            @ai_positive_feeling = true
                            @song.stop
                            @ai_choice_default[0][0] = Gosu::Image.new("media/AI_happy_default.png")
                            @ai_choice_default[0][1] = Gosu::Image.new("media/AI_serenity_default.png")
                            @ai_choice_default[0][2] = Gosu::Image.new("media/AI_excited_default.png")

                            @ai_choice_hover[0][0] = Gosu::Image.new("media/AI_happy_hover.png")
                            @ai_choice_hover[0][1] = Gosu::Image.new("media/AI_serenity_hover.png")
                            @ai_choice_hover[0][2] = Gosu::Image.new("media/AI_excited_hover.png")
                        end
                    end
                end
            end
        end

        def play_Track(current_song, album, album_id)
            @location = album.tracks[current_song].location.chomp
            @song = Gosu::Song.new(@location)
            #puts(location)
            @song.play
        end

        #change the tracks pics
        if @track_open[0]
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button_for_track(mouse_x, mouse_y)
                    when "buitruonglinhtrack1"
                        @track_screen = @track_images[0][0]
                        @current_song = 0
                        @album_id = 0
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "buitruonglinhtrack2"
                        @track_screen = @track_images[0][1]
                        @current_song = 1
                        @album_id = 0
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "buitruonglinhtrack3"
                        @track_screen = @track_images[0][2]
                        @current_song = 2
                        @album_id = 0
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    end
                end
            end
        end

        if @track_open[1]
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button_for_track(mouse_x, mouse_y)
                    when "datgtrack1"
                        @track_screen = @track_images[1][0]
                        @current_song = 0
                        @album_id = 1
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "datgtrack2"
                        @track_screen = @track_images[1][1]
                        @current_song = 1
                        @album_id = 1
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "datgtrack3"
                        @track_screen = @track_images[1][2]
                        @current_song = 2
                        @album_id = 1
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    end
                end
            end
        end

        if @track_open[2]
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button_for_track(mouse_x, mouse_y)
                    when "mrsirotrack1"
                        @track_screen = @track_images[2][0]
                        @current_song = 0
                        @album_id = 2
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "mrsirotrack2"
                        @track_screen = @track_images[2][1]
                        @current_song = 1
                        @album_id = 2
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "mrsirotrack3"
                        @track_screen = @track_images[2][2]
                        @current_song = 2
                        @album_id = 2
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    end
                end
            end
        end

        if @track_open[3]
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button_for_track(mouse_x, mouse_y)
                    when "phuonglytrack1"
                        @track_screen = @track_images[3][0]
                        @current_song = 0
                        @album_id = 3
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "phuonglytrack2"
                        @track_screen = @track_images[3][1]
                        @current_song = 1
                        @album_id = 3
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "phuonglytrack3"
                        @track_screen = @track_images[3][2]
                        @current_song = 2
                        @album_id = 3
                        @album = @albums[@album_id]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    end
                end
            end
        end

        #display mode
        case id
        when Gosu::MsLeft
            case mouse_over_button_for_other_function(mouse_x, mouse_y)
            when "display_mode"
                if @display_mode < @display_mode_images.length()-1
                    @display_mode += 1
                    @display_mode_show = @display_mode_images[@display_mode]
                else
                    @display_mode = 0
                    @display_mode_show = @display_mode_images[@display_mode]
                end
            when "exit_button"
                exit()
            when "favor"
                if @albums[@album_id].tracks[@current_song].favor
                    @albums[@album_id].tracks[@current_song].favor = false
                    @favor_list.delete_at(@favor_count)
                    @favor_count -=1
                else
                    @albums[@album_id].tracks[@current_song].favor = true
                    @favor_list[@favor_count] = @albums[@album_id].tracks[@current_song].location
                    @favor_count += 1
                draw_favor(@albums)
                end
            when "ai"
                if @ai_yes_no
                    @ai_yes_no = false
                else
                    @ai_yes_no = true
                end
                #exit()
            end
        end

        if @display_mode == 0 
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button(mouse_x, mouse_y)
                    #button click
                    when "button1" #random
                        max_value_of_album_id = @albums.length
                        max_value_of_album_id -= 1
                        @album_id = rand(0..max_value_of_album_id)
                        @album = @albums[@album_id]
                        max_value_of_track_in_album = 2
                        @current_song = rand(0..max_value_of_track_in_album)
                        @track_screen = @track_images[@album_id][@current_song]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "button2" #back
                        if @current_song > 0 then
                            @current_song -= 1
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        else
                            if @album_id > 0 then 
                                @album_id -= 1
                            else
                                @album_id = @albums.length-1
                            end
                            @album = @albums[@album_id]
                            @current_song = @album.tracks.length-1
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        end
                    when "button3" #pause
                        @song.pause
                    when "button4" #play
                        @song.play
                    when "button5" #stop
                        @song.stop
                    when "button6" #next
                        if @current_song < @album.tracks.length-1 then
                            @current_song += 1
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        else
                            if @album_id < @albums.length-1 then
                                @album_id +=1
                            else
                                @album_id = 0
                            end
                            @current_song = 0
                            @album = @albums[@album_id]
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        end
                    when "button7" #replay
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    #album click
                    when "album1"
                        toogle_or_draw_button(0)
                    when "album2"
                        toogle_or_draw_button(1)
                    when "album3"
                        toogle_or_draw_button(2)
                    when "album4"
                        toogle_or_draw_button(3)

                    #volume click
                    when "volume1"
                        @song.volume -= 0.1
                        @current_volume = (@song.volume*10).to_i
                        @volume_display = @volume_level[@current_volume]
                    when "volume2"
                        @song.volume += 0.1
                        @current_volume = (@song.volume*10).to_i
                        @volume_display = @volume_level[@current_volume]
                    end
                end
            end

            case id
            when Gosu::KbR
                play_Track(@current_song, @album,@album_id)
            when Gosu::KbEscape
                exit()
            when Gosu::KbSpace
                @song.pause
            when Gosu::KbS
                @song.stop
                @current_song = 0
                @album_id = 0
                @track_screen = @track_images[@album_id][@current_song]
                @song.pause
                draw_favor(@albums)
            when Gosu::KbP
                @song.play
            when Gosu::KbDown
                if @song.volume > 0.05 then
                    @song.volume -= 0.1
                    @current_volume = (@song.volume*10).to_i
                    @volume_display = @volume_level[@current_volume]
                end
            when Gosu::KbUp
                if @song.volume < 1.05 then
                    @song.volume += 0.1
                    @current_volume = (@song.volume*10).to_i
                    @volume_display = @volume_level[@current_volume]
                end
            when Gosu::KbRight
                if @current_song < @album.tracks.length-1 then
                    @current_song += 1
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)
                else
                    if @album_id < @albums.length-1 then
                        @album_id +=1
                    else
                        @album_id = 0
                    end
                    @current_song = 0
                    @album = @albums[@album_id]
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)
                end
            when Gosu::KbLeft
                if @current_song > 0 then
                    @current_song -= 1
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)

                else
                    if @album_id > 0 then 
                        @album_id -= 1
                    else
                        @album_id = @albums.length-1
                    end
                    @album = @albums[@album_id]
                    @current_song = @album.tracks.length-1
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)
                end
            end
        elsif @display_mode == 1 #display by shuffle
            case id
            when Gosu::MsLeft
                begin
                    case mouse_over_button(mouse_x, mouse_y)
                    #button click
                    when "button1" #random
                        max_value_of_album_id = @albums.length
                        max_value_of_album_id -= 1
                        @album_id = rand(0..max_value_of_album_id)
                        @album = @albums[@album_id]
                        max_value_of_track_in_album = 2
                        @current_song = rand(0..max_value_of_track_in_album)
                        @track_screen = @track_images[@album_id][@current_song]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "button2" #back
                        if @current_song > 0 then
                            @current_song -= 1
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        else
                            if @album_id > 0 then 
                                @album_id -= 1
                            else
                                @album_id = @albums.length-1
                            end
                            @album = @albums[@album_id]
                            @current_song = @album.tracks.length-1
                            @track_screen = @track_images[@album_id][@current_song]
                            draw_favor(@albums)
                            play_Track(@current_song, @album,@album_id)
                        end
                    when "button3" #pause
                        @song.pause
                    when "button4" #play
                        @song.play
                    when "button5" #stop
                        @song.stop
                        @current_song = 0
                        @album_id = 0
                        @track_screen = @track_images[@album_id][@current_song]
                        @song.pause
                        draw_favor(@albums)
                    when "button6" #next
                        max_value_of_album_id = @albums.length
                        max_value_of_album_id -= 1
                        @album_id = rand(0..max_value_of_album_id)
                        @album = @albums[@album_id]
                        max_value_of_track_in_album = 2
                        @current_song = rand(0..max_value_of_track_in_album)
                        @track_screen = @track_images[@album_id][@current_song]
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    when "button7" #replay
                        draw_favor(@albums)
                        play_Track(@current_song, @album,@album_id)
                    #album click
                    when "album1"
                        toogle_or_draw_button(0)
                    when "album2"
                        toogle_or_draw_button(1)
                    when "album3"
                        toogle_or_draw_button(2)
                    when "album4"
                        toogle_or_draw_button(3)

                    #volume click
                    when "volume1"
                        @song.volume -= 0.1
                        @current_volume = (@song.volume*10).to_i
                        @volume_display = @volume_level[@current_volume]
                    when "volume2"
                        @song.volume += 0.1
                        @current_volume = (@song.volume*10).to_i
                        @volume_display = @volume_level[@current_volume]
                    end
                end
            end

            case id 
            when Gosu::KbEscape
                exit()
            when Gosu::KbSpace
                @song.pause
            when Gosu::KbS
                @song.stop
                @current_song = 0
                @album_id = 0
                @track_screen = @track_images[@album_id][@current_song]
                @song.pause
                draw_favor(@albums)
            when Gosu::KbP
                @song.play
            when Gosu::KbDown
                if @song.volume > 0.05 then
                    @song.volume -= 0.1
                    @current_volume = (@song.volume*10).to_i
                    @volume_display = @volume_level[@current_volume]
                end
            when Gosu::KbUp
                if @song.volume < 1.05 then
                    @song.volume += 0.1
                    @current_volume = (@song.volume*10).to_i
                    @volume_display = @volume_level[@current_volume]
                end
            when Gosu::KbRight
                max_value_of_album_id = @albums.length
                max_value_of_album_id -= 1
                @album_id = rand(0..max_value_of_album_id)
                @album = @albums[@album_id]
                max_value_of_track_in_album = 2
                @current_song = rand(0..max_value_of_track_in_album)
                @track_screen = @track_images[@album_id][@current_song]
                draw_favor(@albums)
                play_Track(@current_song, @album,@album_id)
            when Gosu::KbLeft
                if @current_song > 0 then
                    @current_song -= 1
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)

                else
                    if @album_id > 0 then 
                        @album_id -= 1
                    else
                        @album_id = @albums.length-1
                    end
                    @album = @albums[@album_id]
                    @current_song = @album.tracks.length-1
                    @track_screen = @track_images[@album_id][@current_song]
                    draw_favor(@albums)
                    play_Track(@current_song, @album,@album_id)
                end
            end
        end
    end
end