# sinatra-playground-2024

## step1: basic setup

```
$ bundle exec ruby app.rb
```

```
http GET http://localhost:4567/ping
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Length: 16
Content-Type: application/json
Date: Sun, 08 Dec 2024 14:15:52 GMT
Server: WEBrick/1.9.1 (Ruby/3.2.4/2024-04-23)
X-Content-Type-Options: nosniff

{
    "success": true
}
```

## step2: DB setup

```
/app # bundle exec ridgepole -c config/database.yml -a
Apply `Schemafile`
-- create_table("users")
   -> 0.0048s
-- create_table("profiles")
   -> 0.0017s
-- add_index("profiles", ["user_id"], {:name=>"profiles_user_id", :unique=>true, :using=>:btree})
   -> 0.0006s
```

```
$ http POST http://localhost:4567/users
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Length: 32
Content-Type: application/json
Date: Sun, 08 Dec 2024 14:47:47 GMT
Server: WEBrick/1.9.1 (Ruby/3.2.4/2024-04-23)
X-Content-Type-Options: nosniff

{
    "created_at": 1733669267,
    "id": 1
}


$ echo '{"display_name":"YusukeIwaki","email":"iwaki@example.com"}' | http PATCH http://localhost:4567/users/1
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Length: 77
Content-Type: application/json
Date: Sun, 08 Dec 2024 14:50:04 GMT
Server: WEBrick/1.9.1 (Ruby/3.2.4/2024-04-23)
X-Content-Type-Options: nosniff

{
    "id": 1,
    "profile": {
        "display_name": "YusukeIwaki",
        "email": "iwaki@example.com"
    }
}
```
