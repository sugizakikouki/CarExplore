class Admins::AdminsController < ApplicationController
    
    def after_sign_in_path_for(resource)
        admins_admins_path
    end
    
    def index
    end
    
    def show
    end
    
    def about
    end
end
