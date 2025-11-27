from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, SubmitField
from wtforms.validators import DataRequired, Length

class PostForm(FlaskForm):
    title = StringField(
            "Title",
            validators=[DataRequired(), Length(max=200)]
    )
    content = TextAreaField(
            "Content",
            validators=[DataRequired(), Length(min=10)]
    )
    submit = SubmitField("Publish")

class CommentForm(FlaskForm):
    content = TextAreaField(
        "Comment",
        validators=[DataRequired(), Length(min=1, max=500)]
    )
    submit = SubmitField("Post Comment")
