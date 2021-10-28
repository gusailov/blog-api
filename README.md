# README

GET api/v1/articles - возможность получить список всех статей отсортированный по дате

GET api/v1/articles/:id - возможность запросить конкретную статью

POST api/v1/articles - создание статьи

DELETE /api/v1/articles/:id - удаление статьи

GET /api/v1/categories/:id - статьи по категории (:id - id категории)

GET /api/v1/users/:id - статьи пользоватея (:id - id пользователя)

GET api/v1/articles/:article_id/comments - возможность получить комментарии к определенной статье

POST api/v1/articles/:article_id/comments - оставить комментарий к статье

DELETE /api/v1/comments/:id - удалить комментарий его автору (:id - id комментария)