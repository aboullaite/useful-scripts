      @Grab('io.github.http-builder-ng:http-builder-ng-okhttp:1.0.2')
      import static groovyx.net.http.HttpBuilder.configure
      import static groovy.json.JsonOutput.toJson
      import groovy.transform.Field
      import groovy.json.*

      @Field String ES_HOST = "YOUR_ES_URL"
      Field String EXPORT_FILE = "YOUR_EXPORTED_DATA"
      def jsonSlurper = new JsonSlurper()
      def reader = new BufferedReader(new InputStreamReader(new FileInputStream(EXPORT_FILE),"UTF-8"))
      data = jsonSlurper.parse(reader)
      println '**** looking for indices ****'
      def map = indecesMap(data, jsonSlurper)
      map.each{ k, v -> println "History of changes => Old: ${k}, New: ${v}" }
      println '**** Importing dashboards and visualizations ****'
      data.each{
        if(it._type == "dashboard")
        addDashboard(it, map, jsonSlurper)
        else{
        addVisualization(it, map, jsonSlurper)
      }
      println '**** All done! ****'
      }

      void addDashboard(Object item, Map map, JsonSlurper js) {
        handleRequest('/.kibana/dashboard/' + item._id, toJson(item._source))
      }

      void addVisualization(Object item, Map map, JsonSlurper js) {
        handleRequest('/.kibana/visualization/' + item._id, toJson(item._source))
      }

      Map indecesMap(Object indices, JsonSlurper jsonSlurper){
        def indecesMap = [:];
        indices.each{
          def index = getIndexOfVisualisation(jsonSlurper, it._source)
          if(it._type == 'visualization' && index != null && !indecesMap.containsKey(index)){
            def newIndex = System.console().readLine "index ${index} found, do you wanna replace it ? (press enter to keep it! )"
            indecesMap.put(index, (newIndex == '')? index : newIndex)
          }
        }

        return indecesMap;
      }

      String getIndexOfVisualisation(JsonSlurper js, Object item){
        def meta = item.kibanaSavedObjectMeta.searchSourceJSON
        if(meta != null)
        return js.parseText(meta).index
        else
        println item._id
      }

      void handleRequest(String uri, String data){
        def posts = configure {
          request.uri = ES_HOST
          request.uri.path = uri
          request.contentType = 'application/json'
          // Replacing space with - bacause the request return 406
          request.body = data.replace(" - ", "-").replace(" ", "-")
          }.put()
        }
