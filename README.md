# README

POST /auth/ body: {
"email":"user@mail.com",
"password":"12345678",
"password_confirmation":"12345678"
} - создает пользователя

POST /auth/sign_in body: {
"email":"user@mail.com",
"password":"12345678"
} - аутентифицирует пользователя

для следующих запросов требующих аутентификацию и авторизацию headers:{access-token:..., client:..., uid:user@mail.com}

GET api/v1/articles - возможность получить список всех статей отсортированный по дате

GET api/v1/articles/:id - возможность запросить конкретную статью

POST api/v1/articles - создание статьи

DELETE /api/v1/articles/:id - удаление статьи

GET /api/v1/categories/:id - статьи по категории (:id - id категории)

GET /api/v1/users/:id - статьи пользоватея (:id - id пользователя)

GET api/v1/articles/:article_id/comments - возможность получить комментарии к определенной статье

POST api/v1/articles/:article_id/comments - оставить комментарий к статье

DELETE /api/v1/comments/:id - удалить комментарий его автору (:id - id комментария)