from flask import render_template, redirect, url_for, flash, request
from . import auth_bp
from .forms import RegisterForm, LoginForm
from app.models import User
from app.extensions import db, bcrypt
from flask_login import login_user, current_user, logout_user, login_required


@auth_bp.route("/register", methods=["GET", "POST"])
def register():
    # If already logged in, redirect to home
    if current_user.is_authenticated:
        return redirect(url_for("blog.index"))

    form = RegisterForm()

    if form.validate_on_submit():
        # Check if email/username exists
        existing_user = User.query.filter(
            (User.email == form.email.data) |
            (User.username == form.username.data)
        ).first()

        if existing_user:
            flash("Username or Email already exists!", "danger")
            return redirect(url_for("auth.register"))

        # Create user
        hashed_pw = bcrypt.generate_password_hash(form.password.data).decode("utf-8")

        user = User(
            username=form.username.data,
            email=form.email.data,
            password_hash=hashed_pw
        )

        db.session.add(user)
        db.session.commit()

        flash("Registration successful! Please log in.", "success")
        return redirect(url_for("auth.login"))

    return render_template("auth/register.html", form=form)

@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    if current_user.is_authenticated:
        return redirect(url_for("blog.index"))

    form = LoginForm()

    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()

        if user and bcrypt.check_password_hash(user.password_hash, form.password.data):
            login_user(user)
            flash("Logged in successfully!", "success")

            next_page = request.args.get("next")
            return redirect(next_page) if next_page else redirect(url_for("blog.index"))
        else:
            flash("Invalid email or password", "danger")

    return render_template("auth/login.html", form=form)

@auth_bp.route("/logout")
@login_required
def logout():
    logout_user()
    flash("You have been logged out.", "info")
    return redirect(url_for("auth.login"))

