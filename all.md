!SLIDE first

# Plato's Forms

## Some examples of Rails best practices.

### Tammer Saleh : tammersaleh.com

!SLIDE

## The importance of code you can believe in.

<img height=500 src="assets/burning_eyes.jpg"/>

!SLIDE

# Authorization

!SLIDE

## As simple as possible

@@@ ruby
    Note.createable?
    Note.createable_by?(user)
    @note.readable?
    @note.readable_by?(user)
    @note.editable?
    @note.editable_by?(user)
    @note.destroyable?
    @note.destroyable_by?(user)
@@@

!SLIDE

## Convention over configuration

!SLIDE

### Template Pattern

+ Methods are defined on ActiveRecord::Base
+ All access is allowed by default
+ Model overrides methods to change access rules

!SLIDE

### app/model/note.rb

@@@ ruby
    class Note < ActiveRecord::Base
      def self.creatable_by?(user)
        user
      end
    
      def editable_by?(user)
        user and user.administrator?
      end
    
      def destroyable_by?(user)
        user and user.administrator?
      end
@@@

!SLIDE

### test/shoulda_macros/active_record_security.rb

@@@ ruby
    module ActiveRecordSecurityMacros
      def should_be_creatable_by(test_name, &user_block)
        should "be creatable by #{test_name}" do
          assert subject.class.creatable_by?(instance_eval(&user_block))
        end
      end
    
      def should_not_be_creatable_by(test_name, &user_block)
        should "not be creatable by #{test_name}" do
          assert !subject.class.creatable_by?(instance_eval(&user_block))
        end
      end
    ...
@@@

!SLIDE

### test/unit/note_test.rb

@@@ ruby
    class NoteTest < ActiveSupport::TestCase
      should_be_creatable_by("administrator") { Factory(:administrator) }
      should_be_creatable_by("user")          { Factory(:user) }
      should_not_be_creatable_by("guests")    { nil }
    ...
@@@

!SLIDE

### test/unit/note_test.rb (cont.)

@@@ ruby
    ...
    context "a note" do
      setup { @note = Factory(:note) }
      subject { @note }
  
      should_be_destroyable_by("administrator") { Factory(:administrator) }
      should_be_editable_by("administrator")    { Factory(:administrator) }
      should_not_be_destroyable_by("owner")     { @note.owner }
      should_not_be_editable_by("owner")        { @note.owner }
      should_be_readable_by("guests")           { nil }
@@@

!SLIDE

The models own the accessors, but do not enforce them.  

That's for the controllers.

!SLIDE

### app/controllers/notes_controller.rb

@@@ ruby
    class NotesController < InheritedResources::Base
      include ControllerAuthorization
@@@

!SLIDE

### lib/controller_authorization.rb

@@@ ruby
    module ControllerAuthorization
      def self.included(c)
        c.before_filter :ensure_can_show_record,    :only => :show
        c.before_filter :ensure_can_create_record,  :only => [:new, :create]
        c.before_filter :ensure_can_edit_record,    :only => [:edit, :update]
        c.before_filter :ensure_can_destroy_record, :only => :destroy
      end

      def ensure_can_create_record
        unless resource_class.creatable?
          return deny_guest unless current_user
          deny_access :flash => "Go Away!", :redirect => root_url
        end
      end
@@@

!SLIDE

# Heroku

!SLIDE

## Free base accounts

!SLIDE

## Zero server administration

!SLIDE

## Impossibly simple deployment

!SLIDE

## Easy to migrate to EY to scale

!SLIDE

# Gems & Plugins

!SLIDE

## For the application

+ *Formtastic*: Simple, semantic forms.
+ *Inherited Resources*: RESTful controller abstraction.
+ *Paperclip*: File uploads via S3.
+ *Authlogic*: Authentication.
+ *Hoptoad*: Production and staging error notifications.

!SLIDE

## For the tests

+ *BlueRidge*: JS Testing Framework.
+ *Shoulda*: The best testing framework in the world.
+ *FactoryGirl*: No more fixtures.

!SLIDE

# Read the book

<img height=500 src="assets/antipatterns-cover.jpg"/>

!SLIDE

<h1 id="questions">?</h1>

