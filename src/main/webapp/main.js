/** @jsx React.DOM */

var transformer = "CMDI2HTML";
const queryInput = window.location.search; //link of the website

if (queryInput.startsWith("?input=") && queryInput.includes("http")){
	var Container = React.createClass({displayName: 'Container',
		getInitialState: function() {
			return {status:"info", msg:"", files: {}};
		},
		addCUrl: function(event) {
			console.log(transformer)
			var that = this;
			var up = new Downloader("rest/multi/" + transformer);
			up.onSuccess = function() {
				if (this.xhr.status === 200) {
					var json = JSON.parse(this.xhr.response);
					console.log("upload success, ret ok", json, this);
					that.setState( {status:"success", msg:"Success", files: json});
				} else {
					console.log("upload success, ret not ok", this);
					that.setState( {status:"danger", msg: this.xhr.response, files: {}});
				}
			};
			this.setState( {ok:true, msg:"Transforming, please wait...", files: {}});
			up.addUrl(event);
		},
		render: function() {
			return (
				React.DOM.div({className: "container"},
					React.DOM.div({className: "row clearfix"},
						React.DOM.div({className: "col-md-12 column"},
							React.DOM.div({className: "jumbotron"},
								React.DOM.h2(null, "Metadata Transformer"),
								React.DOM.p(null, "This web service allows you to convert various metadata formats"),
								React.DOM.hr(null),
								TransformList(),
								SelectBox({addUrl:this.addCUrl}),
								StatusBox({status: this.state.status, text: this.state.msg, progress: this.state.progress}),
								DownloadBox({files: this.state.files}),
								React.DOM.hr(null),
								React.DOM.p(null, "You can also transform files directly from a URL via UI:"),
								React.DOM.pre(null, "https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/?input=URL"),
								React.DOM.p(null, "Or use this service programmatically, e.g., like this:"),
								React.DOM.pre(null, "$ curl -d @input_file -o output_file https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/rest/TransformerName"),
								React.DOM.pre(null, "$ curl -o output_file https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/rest/TransformerName/?input=URL"),
							)
						)
					)
				));
		}
	});
}else{
	var Container = React.createClass({displayName: 'Container',
		getInitialState: function() {
			return {status:"info", msg:"", files: {}};
		},
		upload: function(event) {
			console.log(transformer)
			var that = this;
			var up = new Uploader("rest/multi/" + transformer);
			up.onSuccess = function() {
				if (this.xhr.status === 200) {
					var json = JSON.parse(this.xhr.response);
					console.log("upload success, ret ok", json, this);
					that.setState( {status:"success", msg:"Success", files: json});
				} else {
					console.log("upload success, ret not ok", this);
					that.setState( {status:"danger", msg: this.xhr.response, files: {}});
				}
			};
			this.setState( {ok:true, msg:"Uploading, please wait...", files: {}});
			up.upload(event);
		},
		render: function() {
			return (
				React.DOM.div({className: "container"},
					React.DOM.div({className: "row clearfix"},
						React.DOM.div({className: "col-md-12 column"},
							React.DOM.div({className: "jumbotron"},
								React.DOM.h2(null, "Metadata Transformer"),
								React.DOM.p(null, "This web service allows you to convert various metadata formats"),
								React.DOM.hr(null),
								TransformList(),
								FileUploadBox({onUpload: this.upload}),
								StatusBox({status: this.state.status, text: this.state.msg, progress: this.state.progress}),
								DownloadBox({files: this.state.files}),
								React.DOM.hr(null),
								React.DOM.p(null, "You can also transform files directly from a URL via UI:"),
								React.DOM.pre(null, "https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/?input=URL"),
								React.DOM.p(null, "Or use this service programmatically, e.g., like this:"),
								React.DOM.pre(null, "$ curl -d @input_file -o output_file https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/rest/TransformerName"),
								React.DOM.pre(null, "$ curl -o output_file https://weblicht.sfs.uni-tuebingen.de/converter/MetaDataTransformer/rest/TransformerName/?input=URL"),
							)
						)
					)
				));
		}
	});
}


var TransformList = React.createClass({
	displayName: 'TransformerList',
	handleChange: function(event) {
		var value = event.target.value;
		transformer = value;
	},
	render: function () {
		return (
			React.DOM.select({multiple:false, name: "TransformerSelection", onChange:this.handleChange},
				React.DOM.option({value:"CMDI2HTML", disabled:true}, "Select a transformer"),
				React.DOM.option({value:"CMDI2HTML", disabled:false}, "CMDI2HTML"),
				React.DOM.option({value:"CMDI2Marc", disabled: false}, "CMDI2Marc"),
				React.DOM.option({value:"CMDI2DC", disabled:false}, "CMDI2DC"),
				React.DOM.option({value:"CMDI2JSONLD", disabled:false}, "CMDI2JSONLD"),
				React.DOM.option({value:"Marc2RDFDC", disabled:false}, "Marc2RDFDC"),
				React.DOM.option({value:"Marc2EAD", disabled:false}, "Marc2EAD"),
				React.DOM.option({value:"DC2Marc", disabled:false}, "DC2Marc"),
				React.DOM.option({value:"NaLiDa2Marc", disabled:false}, "NaLiDa2Marc"))

		);
	}
});

var SelectBox = React.createClass({displayName: 'SelectBox',
	propTypes: {
		addUrl: React.PropTypes.func.isRequired
	},
	addUrl: function (event){
		this.props.addUrl(event);
	},
	render: function(){
	return(
		React.DOM.div({className:"SelectBox"},
			React.DOM.button({className: "btn btn-primary", onClick:this.addUrl, style:{marginTop:"1em"}}, "Select"))
	)
	}});

var FileUploadBox = React.createClass({displayName: 'FileUploadBox',
	propTypes: {
		onUpload: React.PropTypes.func.isRequired
	},
	onUpload: function(event) {
		this.props.onUpload(event);
	},
	render: function() {
		var specialAddon = {marginRight:"10px", border:"none", background:"none"};
		return (
			React.DOM.div({className: "fileUploadBox"},
				React.DOM.div({className: "input-group"},
					React.DOM.span({style: specialAddon},
						"Upload your metadata instance:"
					),
					React.DOM.span({className: "btn btn-primary btn-file"},
						"Browse",
						React.DOM.input({type: "file", name: "fileUpload", onChange: this.onUpload})
					)
				)
			)
		);
	}
});

var StatusBox = React.createClass({displayName: 'StatusBox',
	propTypes: {
		status: React.PropTypes.string.isRequired,
		text:  React.PropTypes.string.isRequired
	},
	render: function() {
		var style = {marginTop:"10px"};
		var className="alert alert-" + this.props.status;
		if (this.props.text.length === 0)
			return React.DOM.div(null);		return 	React.DOM.div({className: "statusBox", style: style},
			React.DOM.div({className: className, role: "alert"}, this.props.text)
		) ;
	}
});

function iterateMap(map, fn) {
	var i = 0;
	for (var p in map) {
		if (map.hasOwnProperty(p)) {
			fn(i, p, map[p]);
		}
	}
}

var DownloadBox = React.createClass({displayName: 'DownloadBox',
	propTypes: {
		files: React.PropTypes.object.isRequired
	},
	render: function() {
		var files = [];
		iterateMap(this.props.files, function (i, k, v) {
			files.push(React.DOM.li({key: i, className: "list-group-item"}, React.DOM.a({href: v}, k)));
		});
		var header = $.isEmptyObject(files) ? (React.DOM.span(null)) : (React.DOM.p(null, "Download generated HTML file: "));
		return (React.DOM.div(null, " ", header,
			React.DOM.ul({className: "downloadBox list-group"}, " ", files, " ")
		) );
	}
});

React.renderComponent(Container(null), document.getElementById('main'));

///////////////////////////////////////////////////////////////////////////////
function Downloader(url){
	var that = this;
	that.url = url;

	this.addUrl = function(){
		//send Rest call of form FormData: {url: input_url}, instead of files
		url = "rest/multi/" + transformer;
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function (){
		if (xhr.readyState == 4) {
			if (that.onSuccess)
				that.onSuccess();
			}
		};
		xhr.open('post', url, true);
		var fd = new FormData();
		fd.append("url", queryInput.substring(7));
		xhr.send(fd);
		that.xhr = xhr;
	}

}
function Uploader(url) {
	var that = this;
	that.url = url;
	this.progress = -1;

	this.cancelUpload = function() {
		if (that.xhr)
			that.xhr.abort();
		that.xhr = null;
		that.progress = -1;
		if (that.onCancel)
			that.onCancel();
	};

	var onUploadProgress = function(e) {
		var done = e.position || e.loaded, total = e.totalSize || e.total;
		var percent = Math.floor( done / total * 1000 ) / 10;
		that.progress = percent;
	};

	this.upload = function(event) {
		var xhr = new XMLHttpRequest();
		xhr.addEventListener('progress', onUploadProgress, false);
		if ( xhr.upload ) {
			xhr.upload.onprogress = onUploadProgress;
		}
		xhr.onreadystatechange = function(e) {
			if ( 4 == e.currentTarget.readyState ) {
				that.progress = -1;
				if (that.onSuccess)
					that.onSuccess();
			}
		};

		xhr.open('post', that.url, true);
		var fd = new FormData();
		var finput = event.target;
		for (var i = 0; i < finput.files.length; ++i) {
			console.log('uploading file ', finput.files[i]);
			fd.append('file'+i, finput.files[i]);
		}
		xhr.send(fd);
		that.xhr = xhr;
	};
}
