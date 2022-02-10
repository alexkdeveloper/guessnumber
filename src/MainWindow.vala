using Gtk;

namespace Guessnumber {

    public class MainWindow : Gtk.ApplicationWindow {

   private Stack stack;
   private Box vbox_start_game;
   private Box vbox_game_1;
   private Box vbox_game_2;
   private Entry entry_diapasone;
   private Entry entry_attempts;
   private Entry entry_user_number;
   private Label label_info;
   private Label attempts;
   private Label numbers;
   private Label result;
   private Label info;
   private Label number;
   private Label attempt;
   private Button button_back;
   private Button button_check;
   private Button button_greater;
   private Button button_less;
   private Button button_guessed;
   private string user_numbers="";
   private int attempt_number;
   private int guess_number;
   private int attempt_count=0;
   private int middle;
   private int min;
   private int max;


        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Guess the number!",
                         window_position: WindowPosition.CENTER,
                         resizable: true,
                         height_request: 400,
                         width_request: 400,
                         border_width: 10);
        }

      construct {
      var css_provider = new CssProvider();
      try {
               css_provider.load_from_data(".trying_over {color: red} .guessed {color: green; font-size: 18px} .not_guessed {color: red; font-size: 18px} .show_number {font-weight: bold; font-size: 20px} .no {background-color: red; color: white} .yes {background-color: green; color: white}");
               Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
           } catch (Error e) {
               error ("Cannot load CSS stylesheet: %s", e.message);
       }
       get_style_context().add_class("rounded");
       HeaderBar headerbar = new HeaderBar();
        headerbar.get_style_context().add_class(STYLE_CLASS_FLAT);
        headerbar.show_close_button = true;
        set_titlebar(headerbar);
        button_back = new Button ();
        button_back.get_style_context().add_class("back-button");
        button_back.label = "Back";
        button_back.set_tooltip_text("To the start page");
        headerbar.add(button_back);
        button_back.clicked.connect (go_to_back);

        set_widget_visible(button_back,false);

        stack = new Stack ();
        stack.set_transition_duration (600);
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);
        add (stack);
        var label_welcome = new Label ("Welcome to the game!");
        entry_diapasone = new Entry();
        entry_diapasone.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_diapasone.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
            entry_diapasone.set_text ("");
            entry_diapasone.grab_focus();
           }
        });
        var label_diapasone = new Label.with_mnemonic ("_Numbers from 1 to");
        var hbox_diapasone = new Box (Orientation.HORIZONTAL, 20);
        hbox_diapasone.pack_start (label_diapasone, false, true, 0);
        hbox_diapasone.pack_start (this.entry_diapasone, true, true, 0);
        entry_attempts = new Entry();
        entry_attempts.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_attempts.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
              entry_attempts.set_text("");
              entry_attempts.grab_focus();
           }
        });
        var label_attempt = new Label.with_mnemonic ("_Number of attempts:");
        var hbox_attempt = new Box (Orientation.HORIZONTAL, 20);
        hbox_attempt.pack_start (label_attempt, false, true, 0);
        hbox_attempt.pack_start (this.entry_attempts, true, true, 0);

        var button_start_game_1 = new Button.with_label("You guess");
        button_start_game_1.clicked.connect(start_game_1);
        var button_start_game_2 = new Button.with_label("The program guesses");
        button_start_game_2.clicked.connect(start_game_2);
        
        vbox_start_game = new Box(Orientation.VERTICAL,20);
        vbox_start_game.pack_start(label_welcome,false,true,0);
        vbox_start_game.pack_start(hbox_diapasone,false,true,0);
        vbox_start_game.pack_start(hbox_attempt,false,true,0);
        vbox_start_game.pack_start(button_start_game_1,false,true,0);
        vbox_start_game.pack_start(button_start_game_2,false,true,0);
        stack.add(vbox_start_game);
        label_info = new Label ("");
        label_info.set_line_wrap(true);
        entry_user_number = new Entry();
        entry_user_number.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_user_number.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
            entry_user_number.set_text ("");
           }
        });
        var label_user_number = new Label.with_mnemonic ("_Your number:");
        var hbox_user_number = new Box (Orientation.HORIZONTAL, 20);
        hbox_user_number.pack_start (label_user_number, false, true, 0);
        hbox_user_number.pack_start (this.entry_user_number, true, true, 0);

        button_check = new Button.with_label("CHECK");
        button_check.clicked.connect(check_number);

        attempts = new Label("");
        numbers = new Label("");
        numbers.set_line_wrap(true);
        result = new Label("");

        vbox_game_1 = new Box(Orientation.VERTICAL,20);
        vbox_game_1.pack_start(label_info,false,true,0);
        vbox_game_1.pack_start(hbox_user_number,false,true,0);
        vbox_game_1.pack_start(button_check,false,true,0);
        vbox_game_1.pack_start(attempts,true,false,0);
        vbox_game_1.pack_start(numbers,true,false,0);
        vbox_game_1.pack_start(result,true,false,0);
        stack.add(vbox_game_1);
        info = new Label("");
        info.set_line_wrap(true);
        number = new Label("");
        number.get_style_context().add_class("show_number");
        attempt = new Label("");
        button_greater = new Button.with_label("My number is greater");
        button_greater.get_style_context().add_class("no");
        button_greater.clicked.connect(greater);
        button_less = new Button.with_label("My number is less");
        button_less.get_style_context().add_class("no");
        button_less.clicked.connect(less);
        button_guessed = new Button.with_label("Guessed!");
        button_guessed.get_style_context().add_class("yes");
        button_guessed.clicked.connect(guessed);
        vbox_game_2 = new Box(Orientation.VERTICAL,20);
        vbox_game_2.pack_start(info,false,true,0);
        vbox_game_2.pack_start(number,false,true,0);
        vbox_game_2.pack_start(attempt,false,true,0);
        vbox_game_2.pack_start(button_greater,false,true,0);
        vbox_game_2.pack_start(button_less,false,true,0);
        vbox_game_2.pack_start(button_guessed,false,true,0);
        stack.add(vbox_game_2);
        stack.visible_child = vbox_start_game;
        entry_diapasone.set_text("100");
        entry_attempts.set_text("7");
        add_shortcuts();
        }



   private void start_game(int n){
       if(is_empty(entry_diapasone.get_text())){
           alert("Enter the maximum number of guesses");
           entry_diapasone.grab_focus();
           return;
       }
       if(is_empty(entry_attempts.get_text())){
           alert("Enter the number of attempts");
           entry_attempts.grab_focus();
           return;
       }
       int diapasone = int.parse(entry_diapasone.get_text());
       attempt_number = int.parse(entry_attempts.get_text());
       if(diapasone < 2){
           alert("The maximum number cannot be less than 2");
           entry_diapasone.grab_focus();
           return;
       }
       if(attempt_number < 1){
           alert("The number of attempts cannot be less than 1");
           entry_attempts.grab_focus();
           return;
       }
           switch (n) {
               case 1:
                   guess_number = Random.int_range(1,diapasone + 1);
                   label_info.set_text("Guessed number from 1 to "+diapasone.to_string()+". Guess it in "+attempt_number.to_string()+" tries.");
                   stack.visible_child = vbox_game_1;
                   set_widget_visible(button_back, true);
                   button_check.set_sensitive(true);
                   break;
                case 2:
                   attempt_count++;
                   min = 1;
                   max = diapasone;
                   middle = max/2;
                   number.set_text("Is it number "+middle.to_string()+"?");
                   info.set_text("You guessed a number from 1 to "+max.to_string()+". The program will try to guess it in "+attempt_number.to_string()+" attempts.");
                   attempt.set_text("Attempt No. "+attempt_count.to_string()+". Remaining tries: "+(attempt_number - attempt_count).to_string());
                   stack.visible_child = vbox_game_2;
                   set_widget_visible(button_back, true);
                   button_greater.set_sensitive(true);
                   button_less.set_sensitive(true);
                   button_guessed.set_sensitive(true);          
                   break;
           }
   }

   private void go_to_back(){
      if(!button_check.get_sensitive()||!button_guessed.get_sensitive()){
          reset_game();
          return;
      }
      var dialog_back = new Granite.MessageDialog.with_image_from_icon_name ("Question", "Come back?\nThe game will be reset.", "dialog-question", Gtk.ButtonsType.NONE);
           dialog_back.add_button ("Cancel", 0);
           dialog_back.add_button ("Come back", 1);
           dialog_back.show_all ();
           int res = dialog_back.run ();
           switch (res) {
               case 0:
                   dialog_back.destroy ();
                   break;
               case 1:
                   reset_game();
                   dialog_back.destroy ();
                   break;
           }
   }
   private void start_game_1(){
       start_game(1);
   }
   private void start_game_2(){
       start_game(2);
   }
   private void reset_game(){
       if (stack.get_visible_child()==vbox_game_1){
        user_numbers="";
        attempt_count=0;
        attempts.set_text("");
        numbers.set_text("");
        result.set_text("");
        result.get_style_context().remove_class("not_guessed");
        result.get_style_context().remove_class("guessed");
        attempts.get_style_context().remove_class("trying_over");
        stack.visible_child = vbox_start_game;
        set_widget_visible(button_back,false);
       }else{
           attempt_count = 0;
           attempt.set_text("");
           number.set_text("");
           attempt.get_style_context().remove_class("trying_over");
           stack.visible_child = vbox_start_game;
           set_widget_visible(button_back,false);
       }
   }
   private void check_number(){
       if(is_empty(entry_user_number.get_text())){
           alert("Enter your number");
           entry_user_number.grab_focus();
           return;
       }
       attempt_count++;
       attempts.set_text("Attempt No. "+attempt_count.to_string()+". You have attempts left: "+(attempt_number - attempt_count).to_string());
       int user_number = int.parse(entry_user_number.get_text());
       user_numbers = user_numbers + user_number.to_string()+"  ";
       numbers.set_text(user_numbers);
       entry_user_number.set_text("");
       entry_user_number.grab_focus();
       if(guess_number > user_number){
           result.set_text("My number is greater!");
           result.get_style_context().add_class("not_guessed");
       }else if(guess_number < user_number){
           result.set_text("My number is less!");
           result.get_style_context().add_class("not_guessed");
       }else{
           result.set_text("Guessed!");
           result.get_style_context().remove_class("not_guessed");
           result.get_style_context().add_class("guessed");
           button_check.set_sensitive(false);
           return;
       }
       if(attempt_count == attempt_number){
           attempts.set_text("Trying is over! It was number "+guess_number.to_string());
           attempts.get_style_context().add_class("trying_over");
           button_check.set_sensitive(false);
       }
   }
   private void greater(){
      min = middle;
      middle = (min + max)/2;
      if (min == middle) {
			middle += 1;
	}
    check_game();
   }
   private void less(){
      max = middle;
      middle = (min + max)/2;
      if (max == middle) {
			middle -= 1;
	}  
    check_game();
   }
   private void guessed(){
		max = middle;
		min = middle;
		check_game();
   }
   private void check_game(){
       if (min == max){
           number.set_text("You guessed the number "+min.to_string());
           button_greater.set_sensitive(false);
           button_less.set_sensitive(false);
           button_guessed.set_sensitive(false);
           return;
       }
       attempt_count++;
       number.set_text(middle.to_string()+"?");
      attempt.set_text("Attempt No. "+attempt_count.to_string()+". Remaining tries: "+(attempt_number - attempt_count).to_string());
      if(attempt_count > attempt_number){
        attempt.set_text("Trying is over!");
        number.set_text("");
        attempt.get_style_context().add_class("trying_over");
        button_greater.set_sensitive(false);
        button_less.set_sensitive(false);
        button_guessed.set_sensitive(false);
    }
   }
   private void add_shortcuts () {
    key_press_event.connect ((e) => {
        switch (e.keyval) {
            case Gdk.Key.space:
            case Gdk.Key.KP_Enter:
                if (e.state != 0) {
                    if (stack.get_visible_child()==vbox_game_1){
                        check_number();
                    }
                }
                break;
            case Gdk.Key.Left:
            case Gdk.Key.Home:
                 if(e.state != 0){
                    if(stack.get_visible_child()==vbox_game_1||stack.get_visible_child()==vbox_game_2){
                       go_to_back();
                    }
               }
               break;
        }
        return false;
    });
}
     
     private void set_widget_visible (Gtk.Widget widget, bool visible) {
         widget.no_show_all = !visible;
         widget.visible = visible;
  }

     private bool is_empty(string str){
        return str.strip().length == 0;
        }

     private void alert (string str){
           var dialog = new Granite.MessageDialog.with_image_from_icon_name ("Message", str, "dialog-warning");
               dialog.show_all ();
               dialog.run ();
               dialog.destroy ();
       }
    }
}

