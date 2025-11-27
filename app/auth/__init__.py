from flask import Blueprint
from flask_login import LoginManager
from app.models import User

auth_bp = Blueprint("auth", __name__)

# This function will be called from create_app()
def init_auth(login_manager):
    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

from . import routes
