from flask import Flask
from .config import Config
from .extensions import db, migrate, login_manager, bcrypt
from .auth import init_auth

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    bcrypt.init_app(app)

    login_manager.login_view = "auth.login"
    login_manager.login_message_category = "warning"
    
    init_auth(login_manager)
     
    from app import models

    # Register blueprints
    from .auth import auth_bp
    from .blog import blog_bp

    app.register_blueprint(auth_bp, url_prefix="/auth")
    app.register_blueprint(blog_bp, url_prefix="/")

    return app

