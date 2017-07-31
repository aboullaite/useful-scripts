@Grapes(
    @Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7.1')
)
import static groovyx.net.http.ContentType.TEXT

def taskClient = new groovyx.net.http.HTTPBuilder('http://<SONAR_URL>/api/ce/task?id=TASK_ID')
taskClient.setHeaders(Accept: 'application/json')

def taskResponse = taskClient.get(contentType: TEXT)
def taskSlurper = new groovy.json.JsonSlurper().parse(taskResponse)
def status=taskSlurper.task.status

while ( status == "PENDING" || status == "IN_PROGRESS" ) {
println "waiting for sonar results"
sleep(1000)
}
      assert status != "CANCELED" : "Build fail because sonar project is CANCELED"
      assert status != "FAILED" : "Build fail because sonar project is FAILED"
      qualitygatesClient = new groovyx.net.http.HTTPBuilder('http://<SONAR_URL>//api/qualitygates/project_status?analysisId='+taskSlurper.task.analysisId)
      qualitygatesClient.setHeaders(Accept: 'application/json')
      qualitygatesResponse = qualitygatesClient.get(contentType: TEXT)
      def qualitygates= new groovy.json.JsonSlurper().parse(qualitygatesResponse)
      assert qualitygates.projectStatus.status != "ERROR" : "Build fail because sonar project status is not ok"
      println "Huraaaah! You made it :) Sonar Results are good"

