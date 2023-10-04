import ballerina/http;

type ITunesSearchItem record {
    string collectionName;
    string collectionViewUrl;
};

type ITunesSearchResult record {
    ITunesSearchItem[] results;
};

type Album record {
    string name;
    string url;
};

function searchUrl(string artist) returns string {
    return "/search?term=" + artist;
}

listener http:Listener httpListener = new (8080);

service /itunes on httpListener {
    resource function get album(string artist) returns Album[]|error? {
        http:Client iTunes = check new("https://itunes.apple.com/");
        ITunesSearchResult search = check iTunes->get(searchUrl(artist));
        return from ITunesSearchItem item in search.results
            select {name: item.collectionName, url: item.collectionViewUrl};
    }   
}
