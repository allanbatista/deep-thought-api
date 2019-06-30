# Namespaces

Namespaces are used to organize connections, users and every resource created to be easy to manager and authorizated.

## Permissions

Each namespaces has 3 types of permissions: owner, creator and viewer.

**Namespaces and permissions are only permited to be manager by owners**

## API

### Namespaces

The API implements CRUD following RESTful.

    GET /namespaces

    status: 200
    [
        {
            "created_at": "2019-06-23T20:07:44+00:00",
            "name": "Global",
            "namespace_id": null,
            "updated_at": "2019-06-23T20:07:44+00:00",
            "id": "5d0fdc100133c8746b91386e"
        }
    ]
    
    GET /namespaces/:id

    status: 200
    {
        "created_at": "2019-06-23T20:07:44+00:00",
        "name": "Global",
        "namespace_id": null,
        "updated_at": "2019-06-23T20:07:44+00:00",
        "id": "5d0fdc100133c8746b91386e"
    }

    POST /namespaces
    {
        "name": "Developers",
        "namespace_id": "5d0fdc100133c8746b91386e" # namespace parent
    }

    status: 201
    {
        "created_at": "2019-06-23T20:07:44+00:00",
        "name": "Developers",
        "namespace_id": "5d0fdc100133c8746b91386e",
        "updated_at": "2019-06-23T20:07:44+00:00",
        "id": "xxx"
    }

    PATCH /namespaces/:id
    {
        "name": "Super Global"
    }

    status: 200
    {
        "created_at": "2019-06-23T20:07:44+00:00",
        "name": "Super Global",
        "namespace_id": null,
        "updated_at": "2019-06-23T20:07:44+00:00",
        "id": "5d0fdc100133c8746b91386e"
    }

    DELETE /namespaces/:id
    
    status: 204


### Permission

    GET /namespaces/:namespace_id/permissions

    status: 200
    [
        {
          "created_at"=>"2019-06-23T20:07:44+00:00",
          "namespace_id"=>nil,
          "permissions"=>["owner", "creator", "viewer"],
          "updated_at"=>"2019-06-23T20:07:44+00:00",
          "user_id"=>"user_id,
          "id"=>"zzz"
        }
    ]

    GET /namespaces/:namespace_id/permissions/:id

    status: 200
    {
        "created_at"=>"2019-06-23T20:07:44+00:00",
        "namespace_id"=>nil,
        "permissions"=>["owner", "creator", "viewer"],
        "updated_at"=>"2019-06-23T20:07:44+00:00",
        "user_id"=>"user_id,
        "id"=>"zzz"
    }


    POST /namespaces/:namespace_id/permissions
    {
        "user_id": "zzz",
        "permissions": ["viewer"]
    }

    status: 201
    {
        "created_at"=>"2019-06-23T20:07:44+00:00",
        "namespace_id"=>nil,
        "permissions"=>["viewer"],
        "updated_at"=>"2019-06-23T20:07:44+00:00",
        "user_id"=>"user_id,
        "id"=>"zzz"
    }

    PATCH /namespaces/:namespace_id/permissions/:id
    {
        "permissions": ["viewer", "creator"]
    }

    status: 200
    {
        "created_at"=>"2019-06-23T20:07:44+00:00",
        "namespace_id"=>nil,
        "permissions"=>["viewer"],
        "updated_at"=>"2019-06-23T20:07:44+00:00",
        "user_id"=>"user_id,
        "id"=>"zzz"
    }

    DELETE /namespaces/:namespace_id/permissions/:id

    status: 204
