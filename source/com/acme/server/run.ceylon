import ceylon.html {
    renderTemplate,
    Body,
    Button,
    Div,
    Doctype,
    Head,
    Html,
    Input,
    Meta,
    MimeType,
    Script,
    Title
}
import ceylon.net.http.server {
    newServer,
    startsWith,
    AsynchronousEndpoint,
    Endpoint
}
import ceylon.net.http.server.endpoints {
    RepositoryEndpoint,
    serveStaticFile
}
import ceylon.net.http {
    get
}

"Run the module `com.acme.server`."
shared void run() {
    value index = Html {
        doctype = Doctype.html5;
        lang = "en";
        Head {
            Meta {
                charset = "utf-8";
            },
            Title {"Todo"}
        },
        Body {
            Input {
                id = "task";
            },
            Button {
                id = "add";
                "Add"
            },
            Div {
                id ="todos";
            },
            Script {
                src = "require.js";
            },
            Script {
                type = MimeType.textJavascript;
                "require.config({
                     baseUrl : 'modules'
                 });
                 require(
                     [ 'com/acme/client/1.0.0/com.acme.client-1.0.0' ],
                     function(app) {
                         app.run();
                     }
                 );"
            }
        }
    };
    value modules = RepositoryEndpoint("/modules");
    value static = AsynchronousEndpoint {
        startsWith("/require.js");
        serveStaticFile("www");
        get
    };
    value todo = Endpoint {
        path = startsWith("/");
        service = (req, res) {
            renderTemplate(index, res.writeString);
        };
    };
    newServer {modules, static, todo}.start();
}
