package main
 
import (
    "fmt"
    "log"
    "net/http"
    "io/ioutil"
    //"os"
    "os/exec"
    //"time"
    "encoding/json"
)
func hello(w http.ResponseWriter, r *http.Request) {
    if r.URL.Path != "/" {
        http.Error(w, "404 not found.", http.StatusNotFound)
        return
    }
 
    switch r.Method {
    case "GET":     
         http.ServeFile(w, r, "form.html")
         //time.Sleep(5000 * time.Millisecond)
         
    case "POST":
        reqBody, err := ioutil.ReadAll(r.Body)
        if err != nil {
            log.Fatal(err)
        }
            
        fmt.Printf("%s\n", reqBody)
        m := make(map[string]interface{})
        err = json.Unmarshal(reqBody, &m)
        if err != nil {
            log.Fatal(err)
        }
        if(m["status"].(string)=="firing"){
            alerts := m["groupLabels"].(map[string]interface{})
            if(alerts["alertname"]=="task_high_request_rate"){
                fmt.Println("mon_"+alerts["job"].(string))
                out,err := exec.Command("./scaleservice.sh","mon_"+alerts["job"].(string),"1").Output()
                fmt.Printf("Output:\n %s",string(out))
                fmt.Println(err)
            }else if(alerts["alertname"]=="task_low_request_rate"){
                fmt.Println("mon_"+alerts["job"].(string))
                out,err := exec.Command("./scaleservice.sh","mon_"+alerts["job"].(string),"-1").Output()
                fmt.Printf("Output:\n %s",string(out))
                fmt.Println(err)
            }
        }
        w.Write([]byte("Received a POST request\n"))
        
        // Call ParseForm() to parse the raw query and update r.PostForm and r.Form.
        /*if err := r.ParseForm(); err != nil {
            fmt.Fprintf(w, "ParseForm() err: %v", err)
            return
        }
        //time.Sleep(15000 * time.Millisecond)
        fmt.Fprintf(w, "Post from website! r.PostFrom = %v\n", r.PostForm)
        name := r.FormValue("name")
        address := r.FormValue("address")
        just := r.FormValue("just")
        fmt.Fprintf(w, "Name = %s\n", name)
        fmt.Fprintf(w, "Address = %s\n", address)
        fmt.Fprintf(w, "Just = %s\n", just)*/
        //out,err := exec.Command("./a.out",name,address,just).Output()
        //xxx := os.Stdout
        //cmd.Stderr = os.Stderr
        //fmt.Fprintf(w,"Output:\n %s",string(out))
        //log.Println(err)
    default:
        fmt.Fprintf(w, "Sorry, only GET and POST methods are supported.")
    }
}
 
func main() {
    http.HandleFunc("/", hello)
 
    fmt.Printf("Starting server for listening to HTTP POST alerts...\n")
    if err := http.ListenAndServe("0.0.0.0:2000", nil); err != nil {
        log.Fatal(err)
    }
}
