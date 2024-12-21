require 'gosu'
require 'rubygems'
require_relative 'turtle_easy'
require_relative 'turtle_normal'
require_relative 'turtle_hard'
require_relative 'turtle_nightmare'


module Turtle_ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

Turtle_WIN_WIDTH = 800
Turtle_WIN_HEIGHT = 1000

class MenuMap
    attr_accessor :width, :height, :button
end

class Button
    attr_accessor :x, :y, :image
end

$x_coordinate_of_buttons = Array.new()
$y_coordinate_of_buttons = Array.new()

def setup_button(nummber_of_button, image, x, y)
    button = Button.new()
    button.x, button.y = x, y
    $x_coordinate_of_buttons[nummber_of_button] = x
    $y_coordinate_of_buttons[nummber_of_button] = y
    #puts (nummber_of_button)
    #puts("button #{nummber_of_button}")
    #puts($x_coordinate_of_buttons[nummber_of_button])
    #puts($y_coordinate_of_buttons[nummber_of_button])
    button.image = image 
    #Gosu::Image.new("media/button.png")
    button
end

def draw_button(button)
    button.image.draw(button.x, button.y, Turtle_ZOrder::MIDDLE)
end

def setup_menu_map(filename)
    menu_map = MenuMap.new()

    button_image = Gosu::Image.new("media/button.png")
    menu_map.button = []

    lines = File.readlines(filename).map { |line| line.chomp }
    menu_map.height = lines.size
    menu_map.width = lines[0].size
    #puts(menu_map.height, menu_map.width)
    nummber_of_button = 0
    Array.new(menu_map.height) do |y|
        Array.new(menu_map.width) do |x|
            case lines[y][x,1]
            when "x"
                menu_map.button.push(setup_button(nummber_of_button, button_image, x*50, y*50))
                nummber_of_button += 1
            else
                nil
            end
        end
    end
    menu_map
end

def draw_menu_map(menu_map)
    menu_map.button.each { |b| draw_button(b) }
end

#puts($x_coordinate_of_buttons[0])
#puts($y_coordinate_of_buttons[0])

class MyTurtleWindow < Gosu::Window

    # set up variables and attributes
    def initialize()
        super(Turtle_WIN_WIDTH, Turtle_WIN_HEIGHT, false)
        self.caption = "Menu"
        @background = Gosu::Image.new("media/menu_background.png", :tileable => true)
        @button_font = Gosu::Font.new(20)
        @info_font = Gosu::Font.new(10)
        @menu_map = setup_menu_map("media/turtle_eat_gem_menu.txt")
        @easy = Gosu::Image.new("media/easy.png")
        @normal = Gosu::Image.new("media/normal.png")
        @hard = Gosu::Image.new("media/hard.png")
        @nightmare = Gosu::Image.new("media/nightmare.png")
        @exit = Gosu::Image.new("media/exit.png")
        @button_hover = Gosu::Image.new("media/button_hover.png")
        
    end

    def needs_cursor?; true; end

    def mouse_over_button(mouse_x, mouse_y) 
        if ((mouse_x > $x_coordinate_of_buttons[0] and mouse_x < $x_coordinate_of_buttons[0] + 200) and (mouse_y > $y_coordinate_of_buttons[0] and mouse_y < $y_coordinate_of_buttons[0] + 170))
            return 1
        elsif ((mouse_x > $x_coordinate_of_buttons[1] and mouse_x < $x_coordinate_of_buttons[1] +200 ) and (mouse_y > $y_coordinate_of_buttons[1] and mouse_y < $y_coordinate_of_buttons[1] + 170))
            return 2
        elsif ((mouse_x > $x_coordinate_of_buttons[2] and mouse_x < $x_coordinate_of_buttons[2] + 200) and (mouse_y > $y_coordinate_of_buttons[2] and mouse_y < $y_coordinate_of_buttons[2] + 170))
            return 3
        elsif ((mouse_x > $x_coordinate_of_buttons[3] and mouse_x < $x_coordinate_of_buttons[3] + 200) and (mouse_y > $y_coordinate_of_buttons[3] and mouse_y < $y_coordinate_of_buttons[3] + 170))
            return 4
        elsif ((mouse_x > $x_coordinate_of_buttons[4] and mouse_x < $x_coordinate_of_buttons[4] + 200) and (mouse_y > $y_coordinate_of_buttons[4] and mouse_y < $y_coordinate_of_buttons[4] + 170))
            return 5
        end
    end 

    def draw()
        #draw background and button
        @background.draw 0, 0, 0
        draw_menu_map(@menu_map)

        #draw x,y coordinate
        @info_font.draw("mouse_x: #{mouse_x}", 0, 740, Turtle_ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        @info_font.draw("mouse_y: #{mouse_y}", 0, 720, Turtle_ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)

        #draw text
        @easy.draw($x_coordinate_of_buttons[0] + 55, $y_coordinate_of_buttons[0] + 90, Turtle_ZOrder::TOP)
        @normal.draw($x_coordinate_of_buttons[1] + 40, $y_coordinate_of_buttons[1] + 90, Turtle_ZOrder::TOP)
        @hard.draw($x_coordinate_of_buttons[2] + 55, $y_coordinate_of_buttons[2] + 90, Turtle_ZOrder::TOP)
        @nightmare.draw($x_coordinate_of_buttons[3] + 20, $y_coordinate_of_buttons[3] + 90, Turtle_ZOrder::TOP)
        @exit.draw($x_coordinate_of_buttons[4] + 60 , $y_coordinate_of_buttons[4] + 85, Game_ZOrder::TOP)

        #button_hover
        rect_width = 270
        rec_height = 110
        mouse = mouse_over_button(mouse_x, mouse_y)
        case mouse
        when 1
            @button_hover.draw($x_coordinate_of_buttons[0], $y_coordinate_of_buttons[0] + 30, Turtle_ZOrder::MIDDLE)
        when 2
            @button_hover.draw($x_coordinate_of_buttons[1], $y_coordinate_of_buttons[1] + 30, Turtle_ZOrder::MIDDLE)
        when 3
            @button_hover.draw($x_coordinate_of_buttons[2], $y_coordinate_of_buttons[2] + 30, Turtle_ZOrder::MIDDLE)
        when 4
            @button_hover.draw($x_coordinate_of_buttons[3], $y_coordinate_of_buttons[3] + 30, Turtle_ZOrder::MIDDLE)
        when 5
            @button_hover.draw($x_coordinate_of_buttons[4], $y_coordinate_of_buttons[4] + 30, Turtle_ZOrder::MIDDLE)
        end
    end

    def button_down(id)
        case id
        when Gosu::MsLeft
            case mouse_over_button(mouse_x,mouse_y)
            when 1
                CptnRubyEasy.new.show()
            when 2
                CptnRubyNormal.new.show()
            when 3
                CptnRubyHard.new.show()
            when 4
                CptnRubyNightmare.new.show()
            when 5
                exit()
            end
        end
    end
end

