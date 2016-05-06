import ceylon.html {
    renderTemplate,
    Body,
    Button,
    Doctype {html5},
    Head,
    Html,
    Input,
    Meta,
    MimeType {textJavascript},
    Ol,
    Script,
    Title
}
import ceylon.net.http {get}
import ceylon.net.http.server {
    newServer,
    startsWith,
    AsynchronousEndpoint,
    Endpoint
}
import ceylon.net.http.server.endpoints {
    serveStaticFile,
    RepositoryEndpoint
}

"Run the module `com.acme.server`."
shared void run() {
    value index = Html {
        doctype = html5;
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
            Ol {
                id ="tasks";
            },
            Script {
                src = "require.js";
            },
            Script {
                type = textJavascript;
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
        startsWith("/");
        (_, response) => renderTemplate(index, response.writeString);
        get
    };
    newServer {modules, static, todo}.start();
}
