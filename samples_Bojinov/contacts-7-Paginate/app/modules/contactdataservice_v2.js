exports.updateImage = function(gfs, request, response) {
    var _primarycontactnumber = request.params.primarycontactnumber;
    console.log('Updating image for primary contact number:' + _primarycontactnumber);
    request.pipe(gfs.createWriteStream({
        _id : _primarycontactnumber,
        filename : 'image',
        mode : 'w'
    }));
    response.send("Successfully uploaded image for primary contact number: "+ _primarycontactnumber);
}

exports.getImage = function(gfs, _primarycontactnumber, response) {
    console.log('Requesting image for primary contact number: ' + _primarycontactnumber);
    var imageStream = gfs.createReadStream({
        _id : _primarycontactnumber,
        filename : 'image',
        mode : 'r'
    });
    imageStream.on('error', function(error) {
        response.send('404', 'Not found');
        return;
    });
    response.setHeader('Content-Type', 'image/jpeg');
    imageStream.pipe(response);
};

exports.deleteImage = function(gfs, mongodb, _primarycontactnumber, response) {
    console.log('Deleting image for primary contact number:' + _primarycontactnumber);
    var collection = mongodb.collection('fs.files');
    collection.remove(
	    {_id: _primarycontactnumber, filename: 'image'},
        function (error, contact) {
            if (error) {
                console.log(error);
                return;
            }
            if (contact === null) {
                response.send('404', 'Not found');
                return;
            }
            else {
                console.log('Successfully deleted image for primary contact number:' + _primarycontactnumber);
            }
        }
    );
    response.send('Successfully deleted image for primary contact number: ' + _primarycontactnumber);
}

exports.paginate = function (model, request, response) {
    model.paginate({},
        request.query.page,
        request.query.limit,
        function(error, pageCount, result, itemCount) {
            if (error) {
                console.error(error);
                response.writeHead(500, {'Content-Type' : 'text/plain'});
                response.end('Internal server error');
                return;
            }
            response.json({
                object: 'contacts',
                page_count: pageCount,
                result: result
            });
        }
	);
}
