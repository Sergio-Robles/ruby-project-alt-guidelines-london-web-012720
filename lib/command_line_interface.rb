class CommandLineInterface

    def greet
      
        puts "
        
                                             db   d8b   db d88888b db       .o88b.  .d88b.  .88b  d88. d88888b   d888888b  .d88b.  
                                             88   I8I   88 88'     88      d8P  Y8 .8P  Y8. 88'YbdP`88 88'       `~~88~~' .8P  Y8. 
                                             88   I8I   88 88ooooo 88      8P      88    88 88  88  88 88ooooo      88    88    88 
                                             Y8   I8I   88 88~~~~~ 88      8b      88    88 88  88  88 88~~~~~      88    88    88 
                                             `8b d8'8b d8' 88.     88booo. Y8b  d8 `8b  d8' 88  88  88 88.          88    `8b  d8' 
                                              `8b8' `8d8'  Y88888P Y88888P  `Y88P'  `Y88P'  YP  YP  YP Y88888P      YP     `Y88P'  
                                                                                                                                   
                                                                                                                                   
                                             d888888b db   db d88888b 
                                             `~~88~~' 88   88 88'     
                                                88    88ooo88 88ooooo 
                                                88    88~~~88 88~~~~~ 
                                                88    88   88 88.     
                                                YP    YP   YP Y88888P 
                                                                      
                                                                      
                                             d888888b d88888b  .o88b. db   db db   db db    db d8b   db d888888b d88888b d8888b. 
                                             `~~88~~' 88'     d8P  Y8 88   88 88   88 88    88 888o  88 `~~88~~' 88'     88  `8D 
                                                88    88ooooo 8P      88ooo88 88ooo88 88    88 88V8o 88    88    88ooooo 88oobY' 
                                                88    88~~~~~ 8b      88~~~88 88~~~88 88    88 88 V8o88    88    88~~~~~ 88`8b   
                                                88    88.     Y8b  d8 88   88 88   88 88b  d88 88  V888    88    88.     88 `88. 
                                                YP    Y88888P  `Y88P' YP   YP YP   YP ~Y8888P' VP   V8P    YP    Y88888P 88   YD 
                                              "
     

    end

    def menu

        puts "_________________________________________________________________________________"
        puts ""
        puts "Insert the user name to continue:"
        puts ""
        puts "_________________________________________________________________________________"

        @user_name  = gets.chomp.to_s

        @user_instance = User.find_by(user_name: @user_name)
        puts ""
        puts "_________________________________________________________________________________"

        #check if the user exist in case it send the user to crate a new user 

        if  @user_instance 

            mainscreen

        else
            create_username 
          
        end

    end   

    def mainscreen

        @all_orders = @user_instance.orders
        @all_products = @user_instance.products
        
        puts "_________________________________________________________________________________"
        puts ""

        puts "Welcome back #{@user_name}"
        puts "_________________________________________________________________________________"
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
        puts "_________________________________________________________________________________"
        
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
            exit
        else
            puts "Insert valid option please try again."
            mainscreen
        end

    end


    def create_username

        puts "_________________________________________________________________________________"

        puts "Your name is not registered, please insert nickname to create a new user:"
        

        @user_name = gets.chomp.gsub(/\s+/, "")
      
        if User.all.find_by(user_name: @user_name)
            puts "Sorry this nickname is taken try again"
            create_username
        else

        puts "_________________________________________________________________________________"

        @user_instance = User.create(user_name: "#{@user_name}")
        end 
        mainscreen

    end


    def order_history

        puts "_________________________________________________________________________________"
        puts ""

        if @all_products.size <= 0 
            puts "Your order list is empty."
            puts "Press any key to go back to main menu."

            puts "_________________________________________________________________________________"
        else
            @all_products.map do |p|

            puts "You have ordered a #{p.product_type}, for £#{p.product_price}."
    
            puts "_________________________________________________________________________________"

            end
        end

        puts "_________________________________________________________________________________"
        puts ""
        puts "Press any key to go back to main menu."

        puts "_________________________________________________________________________________"

        order_sent_back = gets.chomp

        if order_sent_back
         mainscreen
        end

    end

    def list_option
        
        puts "_________________________________________________________________________________ "
        puts ""
        puts "Press 1 to see our catalogue or press 2 to insert budget:"
        puts "_________________________________________________________________________________"

        list = gets.chomp.to_i
        if list == 1 
            list_of_tech
        elsif list == 2 
            return insert_budget
        else 
            puts "Enter a valid option please."
            list_option
        end
            
    end
            
    def insert_budget

        puts "Insert budget:"
        puts "_________________________________________________________________________________ "

        user_budget = gets.chomp.to_i
        if user_budget > 0
          
            @product_budget = Product.all.select {|p|p.product_price <= user_budget}
            puts "_________________________________________________________________________________"
            puts ""
            puts "Yout budget allow you to buy:"
            puts "_________________________________________________________________________________"
            puts ""
                @product_budget.each_with_index do |p, i|
                    puts "#{i +=1}\t #{p.product_type}, which cost #{p.product_price} product ID #{p.id}"
                    puts ""
                end
        else 
            puts "Insert correct amount, please:"
            insert_budget
        end       
    
        create_product 

    end


    def create_product

        puts "_________________________________________________________________________________"
        puts ""
        puts "Select the ID of your chosen product"
        puts "_________________________________________________________________________________"
        puts ""

        user_choice = gets.chomp.to_i

        if user_choice > 0 && Product.all.find_by(id:user_choice) #check if the user input a number and is more than 0 and exist

        p = Product.find_by(id: user_choice)#store the product instance 
        new_order = Order.new(user_id: @user_instance.id, product_id: p.id, date: 2020).save #create and save the new ordere
            
        puts""
        puts "You have selected #{p.product_type} which cost #{p.product_price}"
        puts "_________________________________________________________________________________"
        puts ""
        puts"Your order has successfully been processed"
        puts ""
        puts "_________________________________________________________________________________"
        @all_products.reload
        @all_orders.reload
        else 
            puts "this product does not exist"
            create_product
        end

        mainscreen 

    end



    def update_order

        puts "What is in your cart?"
       
        @all_orders.select {|o| puts "A #{o.product.product_type} with an order ID  #{o.id}"}

        puts "_________________________________________________________________________________"
        puts ""
        
        puts "Please enter your product ID to update:"

        puts "_________________________________________________________________________________"
        puts ""

        @order_id = gets.chomp.to_i #order_id_to_update

        if @order_id > 0 && Order.all.find_by(id: @order_id)
            update_product2
        else
            puts "invalid input try again"
            update_order
        end

    end

    def update_product2

        puts "Choose another product "
        puts "________________________________________________________________"

        Product.all.each {|p|puts "#{p.id}. #{p.product_type}"}

        puts "________________________________________________________________"

        puts "Choose a new product by id "

        puts "_______________________________________________________________"

        @product_id = gets.chomp.to_i #new_product_id integer 
            
        o = @all_orders.find_by(id: @order_id) #find order by id, update the product and save it 
        o.update(product_id: @product_id)
        o.save

        @all_products.reload
        @all_orders.reload

        puts ""
        puts "Thank you for changing your order to a #{o.product.product_type}!"
        puts""

        puts "_________________________________________________________________________________"
        puts ""
        puts "Press any key to go back to main menu."
        puts "_________________________________________________________________________________"
        puts ""

        input = gets.chomp
        if input 
            mainscreen 
        end
    end


    def delete_user_order

        if @all_orders.size <= 0
            puts "You have no orders. Have a look to our catelogue!"
            mainscreen
        else
            puts "_________________________________________________________________________________"
            puts ""
            puts "Please enter your order ID to cancel:"
            puts ""


            @all_orders.select {|o| puts "A #{o.product.product_type} with an order ID  #{o.id}"}
            @deleted_item = Order.all.find_by(id: gets.chomp.to_i)
            delete_user_order2 
          
        end

    end   

    def delete_user_order2

        puts "#{@user_name}, are you sure you want to cancel your order of #{@deleted_item.product.product_type}?"

        puts "Type 'y' or 'n'"
        answer = gets.chomp

        case answer

        when "n"
            mainscreen
        when "y"
            @deleted_item.destroy
            @all_orders.reload
            @all_products.reload
            puts "Your #{@deleted_item.product.product_type} has been successfully cancelled."
            mainscreen
        else
            puts "invalid input please type a valid option"
            delete_user_order2
        end

        puts "_________________________________________________________________________________"

    end


    def list_of_tech

        puts "_________________________________________________________________________________"
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
           "

        puts "_________________________________________________________________________________"
        puts ""
        puts "Press 1 to make a purchase or press 2 to go back to the main menu."

        puts "_________________________________________________________________________________"
        puts ""

        input = gets.chomp.to_i
        if input == 1
            insert_budget
        elsif input == 2
            mainscreen 
        else 
            puts "invalid option please try again"
            list_of_tech

        end

    end
end
