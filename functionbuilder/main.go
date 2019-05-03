/////////////////*****************************////////////////////////
//TO ADD YOUR FUNCTION, THERE ARE TWO STEPS
// 1. SPECIFY THE FIELDS AND ARGUMENTS IN THE POST FUNCTION
// 2. SPECIFY THE PORT FOR THE FUNCTION TO TAKE REQUESTS
/////////////////*****************************////////////////////////
package main
 
import (
    "fmt"    
    "log"
    "net/http"
    "os/exec"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
    
)
var (
  counter = prometheus.NewCounterVec(
    prometheus.CounterOpts{
        Name: "api_requests_total",
        Help: "A counter for requests to the wrapped handler.",
    },
    []string{"code", "method"},
)


duration = prometheus.NewHistogramVec(
    prometheus.HistogramOpts{
        Name:    "request_duration_seconds",
        Help:    "A histogram of latencies for requests.",
        Buckets: []float64{.25, .5, 1, 2.5, 5, 10},
    },
    []string{"handler", "method"},
)


responseSize = prometheus.NewHistogramVec(
    prometheus.HistogramOpts{
        Name:    "response_size_bytes",
        Help:    "A histogram of response sizes for requests.",
        Buckets: []float64{200, 500, 900, 1500},
    },
    []string{},
)
)
func hello(w http.ResponseWriter, r *http.Request) {
    if r.URL.Path != "/" {
        http.Error(w, "404 not found.", http.StatusNotFound)
        return
    }
 
    switch r.Method {
    case "GET":
         http.ServeFile(w, r, "form.html")
    case "POST":
        if err := r.ParseForm(); err != nil {
            fmt.Fprintf(w, "ParseForm() err: %v", err)
            return
        }
        ////********** STEP 1, SPECIFY ARGUMENTS FOR POST REQUEST, add any extra triggers, code etc
        name := r.FormValue("name")
        address := r.FormValue("address")
        out,err := exec.Command("./b",name,address).Output()
        fmt.Fprintf(w,"Output:\n %s",string(out))
        log.Println(err)
        ////**********END of STEP1
    default:
        fmt.Fprintf(w, "Sorry, only GET and POST methods are supported.")
    }
}
 
func main() {  
http.Handle("/metrics", promhttp.Handler())
    http.Handle("/",promhttp.InstrumentHandlerDuration(duration.MustCurryWith(prometheus.Labels{"handler": "hello"}),
        promhttp.InstrumentHandlerCounter(counter,
            promhttp.InstrumentHandlerResponseSize(responseSize, http.HandlerFunc(hello)),
        ),
    ))
    prometheus.MustRegister(counter)
    prometheus.MustRegister(duration)
    prometheus.MustRegister(responseSize)
 
    fmt.Printf("Starting server for testing HTTP POST...\n")
    ///************ STEP 2, SPECIFY PORT from 2000-9000, avoiding conflicting ones
    if err := http.ListenAndServe("0.0.0.0:8790", nil); err != nil {
        log.Fatal(err)
    }
    ///************ END of STEP 2
}
