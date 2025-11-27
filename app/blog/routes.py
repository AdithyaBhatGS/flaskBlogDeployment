from . import blog_bp
from flask import render_template, redirect, url_for, flash, request, abort
from flask_login import login_required, current_user
from app.blog.forms import PostForm, CommentForm
from app.models import Post, Comment
from app.extensions import db

@blog_bp.route("/")
def index():
    posts = Post.query.order_by(Post.created_at.desc()).all()
    return render_template("blog/index.html", posts=posts)

@blog_bp.route("/create", methods=["GET", "POST"])
@login_required
def create_post():
    form = PostForm()

    if form.validate_on_submit():
        new_post = Post(
            title=form.title.data,
            content=form.content.data,
            user_id=current_user.id
        )
        db.session.add(new_post)
        db.session.commit()

        flash("Post created successfully!", "success")
        return redirect(url_for("blog.index"))

    return render_template("blog/create_post.html", form=form, page_title="Create Post")

@blog_bp.route("/edit/<int:post_id>", methods=["GET", "POST"])
@login_required
def edit_post(post_id):
    post = Post.query.get_or_404(post_id)

    # Only the owner can edit
    if post.user_id != current_user.id:
        abort(403)  # Forbidden

    form = PostForm(obj=post)  # pre-fill form with existing data

    if form.validate_on_submit():
        post.title = form.title.data
        post.content = form.content.data
        db.session.commit()
        flash("Post updated successfully!", "success")
        return redirect(url_for("blog.index"))

    return render_template("blog/create_post.html", form=form, page_title="Edit Post")


@blog_bp.route("/delete/<int:post_id>", methods=["POST"])
@login_required
def delete_post(post_id):
    post = Post.query.get_or_404(post_id)

    # Only the owner can delete
    if post.user_id != current_user.id:
        abort(403)  # Forbidden

    db.session.delete(post)
    db.session.commit()
    flash("Post deleted successfully!", "success")
    return redirect(url_for("blog.index"))


@blog_bp.route("/post/<int:post_id>", methods=["GET", "POST"])
@login_required
def post_detail(post_id):
    post = Post.query.get_or_404(post_id)
    form = CommentForm()

    if form.validate_on_submit():
        new_comment = Comment(
            content=form.content.data,
            post_id=post.id,
            user_id=current_user.id
        )
        db.session.add(new_comment)
        db.session.commit()
        flash("Comment added!", "success")
        return redirect(url_for("blog.post_detail", post_id=post.id))

    return render_template("blog/post_detail.html", post=post, form=form)


@blog_bp.route("/comment/edit/<int:comment_id>", methods=["GET", "POST"])
@login_required
def edit_comment(comment_id):
    comment = Comment.query.get_or_404(comment_id)

    # Only owner can edit
    if comment.user_id != current_user.id:
        abort(403)

    form = CommentForm(obj=comment)

    if form.validate_on_submit():
        comment.content = form.content.data
        db.session.commit()
        flash("Comment updated successfully!", "success")
        return redirect(url_for("blog.post_detail", post_id=comment.post_id))

    return render_template("blog/edit_comment.html", form=form)

@blog_bp.route("/comment/delete/<int:comment_id>", methods=["POST"])
@login_required
def delete_comment(comment_id):
    comment = Comment.query.get_or_404(comment_id)

    # Only owner can delete
    if comment.user_id != current_user.id:
        abort(403)

    post_id = comment.post_id
    db.session.delete(comment)
    db.session.commit()
    flash("Comment deleted successfully!", "success")
    return redirect(url_for("blog.post_detail", post_id=post_id))

