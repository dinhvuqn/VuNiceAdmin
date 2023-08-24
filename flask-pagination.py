from flask import Blueprint
from flask_paginate import Pagination, get_page_parameter

mod = Blueprint('users', __name__)


@mod.route('/')
def index():
    search = False
    q = request.args.get('q')
    if q:
        search = True

    page = request.args.get(get_page_parameter(), type=int, default=1)

    users = User.find(...)
    pagination = Pagination(page=page, total=users.count(), search=search, record_name='users')
    # 'page' is the default name of the page parameter, it can be customized
    # e.g. Pagination(page_parameter='p', ...)
    # or set PAGE_PARAMETER in config file
    # also likes page_parameter, you can customize for per_page_parameter
    # you can set PER_PAGE_PARAMETER in config file
    # e.g. Pagination(per_page_parameter='pp')

    return render_template('users/index.html',
                           users=users,
                           pagination=pagination,
                           )
