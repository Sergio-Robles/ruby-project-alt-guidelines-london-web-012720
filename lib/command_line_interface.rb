require 'colorize'

class CommandLineInterface

    def title 
    puts ""
    puts ""
    puts ""
    puts "_________________________________________________________________________________________________________________________"
    puts "_________________________________________________________________________________________________________________________"
    puts ""
    puts ""
    puts ""
    puts "
            

               ████████╗███████╗ ██████╗██╗  ██╗    ██╗  ██╗██╗   ██╗███╗   ██╗████████╗███████╗██████╗             
               ╚══██╔══╝██╔════╝██╔════╝██║  ██║    ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗            
   █████╗█████╗   ██║   █████╗  ██║     ███████║    ███████║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗█████╗
   ╚════╝╚════╝   ██║   ██╔══╝  ██║     ██╔══██║    ██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗╚════╝╚════╝
                  ██║   ███████╗╚██████╗██║  ██║    ██║  ██║╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║            
                  ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝            
                                                                                                             
        ".colorize(:light_blue)
    puts ""
    puts ""
    end
    
    def greet
    
        puts "_________________________________________________________________________________________________________________________"
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "                                            WELCOME TO TECH HUNTER ".colorize(:light_blue)
        puts "_________________________________________________________________________________________________________________________"
        

    end

    def menu

        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Please insert the user name to continue:"
        puts ""
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        @user_name  = gets.chomp.to_s

        @user_instance = User.find_by(user_name: @user_name)
        puts ""
        puts "_________________________________________________________________________________________________________________________"

        if  @user_instance 

            mainscreen

        else
            create_username 
          
        end

    end   

    def mainscreen

        @all_orders = @user_instance.orders
        @all_products = @user_instance.products
        
        puts "_________________________________________________________________________________________________________________________"
        puts ""

        puts "Welcome #{@user_name}! Nice to see you here.".colorize(:light_blue)
        puts "_________________________________________________________________________________________________________________________"
        puts "


        What would you like to do?

        1. Order history
        2. Create a new order
        3. Update your order 
        4. Cancel your order
        5. View the catalogue
        6. Go back to the login page
        7. Exit application
        "      
        puts ""
        puts ""
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        
        mainscreen_options = gets.chomp.to_i
        case mainscreen_options
        when 1
            order_history       
        when 2
            list_option
        when 3
            update_order 
        when 4
            delete_user_order 
        when 5
            list_of_tech 
        when 6
            menu 
        when 7
            pid = fork{ exec "afplay", "lib/soundfile/Ending.mp3" }
            exit
        else
            puts "Insert valid option please try again.".colorize(:red) 
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            mainscreen
        end
        puts ""
    end


    def create_username
        puts ""
        puts "Your name is not registered, please insert nickname to create a new user:".colorize(:red)
        pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
        puts ""
        
        @user_name = gets.chomp.to_s
            if @user_name.blank? 
                puts ""
                puts "Sorry but that username is not valid."
                puts ""
                menu
            end

        puts "_________________________________________________________________________________________________________________________"

        @user_instance = User.create(user_name: "#{@user_name}")

        mainscreen

    end


    def order_history

        puts "_________________________________________________________________________________________________________________________"
        puts ""

        if @all_products.size <= 0 
            puts ""
            puts "Your order list is empty. Please read our catalogue on the main menu and create a new order.".colorize(:light_blue)
            puts ""
            # puts "Press any key to go back to main menu."
        else
            @all_products.map do |p|
            puts "You have ordered a #{p.product_type}, for £#{p.product_price}.".colorize(:light_blue)
            puts""
            end
        end

        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Press any key to go back to main menu."
        puts ""
        order_sent_back = gets.chomp
        if order_sent_back
         mainscreen
        end

    end

    def list_option
        
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Press 1 to see our catalogue or press 2 to insert budget:"
        puts "_________________________________________________________________________________________________________________________"

        list = gets.chomp.to_i
        if list == 1 
            list_of_tech
        elsif list == 2 
            return insert_budget
        else 
            puts "Enter a valid option please.".colorize(:red)
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            list_option
        end
            
    end
            
    def insert_budget
        puts ""
        puts "Insert budget:"
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        user_budget = gets.chomp.to_i
        puts ""
        if user_budget >= 100
            @product_budget = Product.all.select {|p|p.product_price <= user_budget}
            puts "_________________________________________________________________________________________________________________________"
            puts ""
            puts "Your budget allow you to buy:"
            puts "_________________________________________________________________________________________________________________________"
            puts ""
                @product_budget.each_with_index do |p, i|
                    puts "#{p.product_type}, which cost #{p.product_price} product ID #{p.id}".colorize(:light_blue)
                    puts ""
                end
        else 
            puts ""
            puts "You don't have budget to buy anything, get a job!!!".colorize(:red)
            puts ""
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            mainscreen
        end       
    
        create_product 

    end


    def create_product

        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Select the ID of your chosen product"
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        
        user_choice = gets.chomp.to_i

        puts ""
        num = Product.all.size
        if user_choice.clamp(0, num)

            p = Product.find_by(id: user_choice)#return instance of the product 
            new_order = Order.new(user_id: @user_instance.id, product_id: p.id, date: 2020).save
    
            puts""
            puts "You have selected #{p.product_type} which cost #{p.product_price}".colorize(:light_blue)
            puts "_________________________________________________________________________________________________________________________"
            puts ""
            puts "Your order has successfully been processed.".colorize(:green)
            pid = fork{ exec "afplay", "lib/soundfile/purchase-succed-sound.mp3" }
            puts ""
            puts "_________________________________________________________________________________________________________________________"
            @all_products.reload

        mainscreen 
        else
            puts "_________________________________________________________________________________________________________________________"
            puts ""
            puts "Please insert a correct number.".colorize(:red)
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            puts ""
            puts "_________________________________________________________________________________________________________________________"
            create_product
        end

    end



    def update_order
        puts ""
        puts "What is in your cart?"
        puts ""
        @all_orders.select do |o| 
            puts "A #{o.product.product_type} with an order ID  of #{o.id}.".colorize(:light_blue)
        end
        
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        
        puts "Please enter your product ID to update:" 
        
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        
        order_id = gets.chomp.to_i #order_id_to_update 
        order_id_check = Order.all.map { |x| x.id}
        puts ""
        puts "_________________________________________________________________________________________________________________________"
        if order_id_check.include?(order_id) == false
            puts ""
            puts "Wrong ID, your update has been cancelled.".colorize(:red)
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            puts ""
            mainscreen
        else
            puts ""
            puts "Choose another product by ID from the list:" 
            puts ""
            
            Product.all.each {|p|puts "Press #{p.id} ID for #{p.product_type}."} 
            
            puts ""
            puts "_________________________________________________________________________________________________________________________"
            puts ""
            
            product_id = gets.chomp.to_i #new_product_id
            product_id_check = Order.all.map { |x| x.product_id}
            if product_id_check.include?(product_id) == false
                puts "_________________________________________________________________________________________________________________________"
                    puts ""
                    puts "Wrong ID, your update has been cancelled.".colorize(:red) 
                    pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
                    puts ""
                    mainscreen 
            end
            o = @all_orders.find_by(id: order_id)
            o.update(product_id: product_id)
            o.save   
        end



        @all_products.reload
        @all_orders.reload

        puts ""
        puts "Your order has been updated successfully!".colorize(:green)
        pid = fork{ exec "afplay", "lib/soundfile/purchase-succed-sound.mp3" }
        puts""

        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Press any key to go back to main menu."
        puts "_________________________________________________________________________________________________________________________"
        puts ""

        input = gets.chomp
        if input 
            mainscreen 
        end
        puts ""
    end
    



    def delete_user_order
        puts ""
        if @all_orders.size <= 0
            puts "You have no orders. Have a look to our catelogue!".colorize(:light_blue)
            mainscreen
        else
            puts "_________________________________________________________________________________________________________________________"
            puts ""
            puts "Please enter your order ID to cancel:"
            puts ""

            @all_orders.select do |o|
                puts "A #{o.product.product_type} with an order ID  #{o.id}.".colorize(:light_blue)
            end
        end
        
        
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        deleted_item = @all_orders.find_by(id: gets.chomp.to_i)
        #binding.pry
        puts ""
        if deleted_item            
                deleted_item.destroy
                puts "Your #{deleted_item.product.product_type} has been successfully cancelled.".colorize(:green)
                pid = fork{ exec "afplay", "lib/soundfile/purchase-succed-sound.mp3" }
                @all_orders.reload
                @all_products.reload 
                mainscreen
        else 
                puts "Please insert a valid answer to proceed with the cancellation.".colorize(:red)
                pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
                delete_user_order

        end
            #I deleted the question Y/N because it was giving troubles with test validation.
            puts "_________________________________________________________________________________________________________________________"
            puts ""

    end   



    def list_of_tech
        puts ""
        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Welcome to the catelogue!

       1. Smart TV... £200
           Connect this TV to your internet and stream to your hearts
           content. Stream music and videos, browse the internet and view
           photos... the world is your oyster!

       2. Wireless speaker system... £100
           This wireless speaker system includes speakers for up to 5 rooms,
           these speakers can be paired and controlled from a mobile app
           creating a cool vibe all around the house.

       3. Thermostat... £300
           This super thermostat automatically regulates temperature. It
           can also be paired and controlled via a mobie app so you can turn
           the heating up just in time for when you get home!

       4. Home security system... £400
           Protect your home and your family with the security system.
           This includes high decibel alarms, CCTV, motione detectors,
           a control panel and more.

       5. Domestic... £500
           Forgot to feed your dog? Well that's not a problem with the
           Domestic2000! Give your dog a little pick me up or a treat for
           when you're missing him.

       6. Smoke/CO detector... £800
           Protect you and your family with this smoke and carbon monoxide
           detector. This fire-protection device automatically detects and
           gives warning when there is a presence of smoke.

       7. Lighting... £300
           The perfect modern chandelier to lilght up any room! Suitable for
           most rooms and it absolutely stunning. You can transform a room in
           seconds with this lighting.

       8. Doors... £200
           Made from quality solid oak, these doors are perfect for making
           the room feel complete.

       9. Laundry machine... £400
           Powerful washing machine and tumble drier combination, perfect for
           any busy household. Quick and reliable, your new best friend!

       10. Water detector... £700
           Detect the presence of water to provide an alert in time to prevent
           a serious water leak.

       11. Monitoring system... £100
           The perfect start-up CCTV kit for any home. This budget item is great
           if you just want that extra protection and monitoring whilst you're
           away from your home.
           ".colorize(:light_blue)

        puts "_________________________________________________________________________________________________________________________"
        puts ""
        puts "Press 1 to make a purchase or press 2 to go back to the main menu."
        puts "_________________________________________________________________________________________________________________________"
        puts ""

        input = gets.chomp.to_i
        if input == 1
            insert_budget
        elsif input == 2
            mainscreen 
        else 
            puts "Please, insert valid number.".colorize(:red)
            pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }
            list_of_tech 
        end
        puts ""
        puts "_________________________________________________________________________________________________________________________"
        puts ""
    end

end