use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Static does Plackdo::Middleware {

    use Plackdo::App::File;

    has $!root = '.';
    has $!path;
    has $!file_app;
    has $!encoding = 'utf-8';
    has $!conditional_get = 1;

    method call (%env) {
        my $res = self.handle_static(%env);
        return $res if $res;
        return &!app(%env);
    }

    method handle_static (%env) {
        $!path // return;
        my $path = %env<PATH_INFO>;
        $path ~~ $!path or return;
        $!file_app //= Plackdo::App::File.new(
            root => $!root,
            encoding => $!encoding,
            conditional_get => $!conditional_get,
        );

        return $!file_app.call(%env);
    }
}

# vim: ft=perl6
