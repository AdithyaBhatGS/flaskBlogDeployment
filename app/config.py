import os


#class Config:
#    SECRET_KEY = os.environ.get("SECRET_KEY", "devsecret")
#
#    SQLALCHEMY_DATABASE_URI = os.environ.get(
#        "DATABASE_URI",
#        "mysql://root:password@mysql:3306/blogdb"
#    )
#
#    SQLALCHEMY_TRACK_MODIFICATIONS = False
#
#
#
#class Config:
#    SQLALCHEMY_DATABASE_URI = os.environ.get(
#        "DATABASE_URI",
#        "sqlite:///blog.db"
#    )
#    SQLALCHEMY_TRACK_MODIFICATIONS = False
#    SECRET_KEY = os.environ.get(
#        "SECRET_KEY",
#        "supersecretkey"
#    )

# import os

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "devsecret")
    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{os.environ.get('DB_USER')}:{os.environ.get('DB_PASSWORD')}"
        f"@{os.environ.get('DB_HOST')}:{os.environ.get('DB_PORT')}/{os.environ.get('DB_NAME')}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

