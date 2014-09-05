# accept large uploads
normal[:nginx][:client_max_body_size] = "32m"

# gzip tweaks
default[:nginx][:gzip_comp_level] = "5"
default[:nginx][:gzip_types] = ["application/atom+xml",
                                "application/javascript",
                                "application/json",
                                "application/rss+xml",
                                "application/x-font-ttf",
                                "application/x-javascript",
                                "application/x-web-app-manifest+json",
                                "application/xhtml+xml",
                                "application/xml",
                                "application/xml+rss",
                                "font/opentype",
                                "image/svg+xml",
                                "image/x-icon",
                                "text/css",
                                "text/javascript",
                                "text/plain",
                                "text/x-component",
                                "text/xml"]
