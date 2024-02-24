from rest_framework.pagination import PageNumberPagination


class PageNumberAndLimitPagination(PageNumberPagination):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.page_size_query_param = "limit"
