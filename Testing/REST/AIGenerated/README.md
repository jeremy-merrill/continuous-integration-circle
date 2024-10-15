# REST endpoint for computing Lung Cancer Risk

[Uses Rserve](https://www.rforge.net/Rserve/) to communicate with the `lcrisks` R library.

There are two endpoints:
- `evaluate` (POST) - Performs the risk calculation based on the supplied inputs (see below).
- `ping` (GET) Indicates if the service is running and can connect to the Rserve endpoint.

To perform a risk calculation, submit a POST request to the `evaluate` endpoint.  

Here is a sample request payload:
<pre>
{
    "age": 80,
    "angina": 0,
    "bmi": 31.62,
    "bron": 0,
    "chd": 0,
    "cigs_per_day": 40,
    "diab": 0,
    "emp": 0,
    "famlungtrend": 0,
    "healthy": "true",
    "heartattack": 0,
    "heartdisease": 0,
    "hypertension": 1,
    "kidney": 0,
    "liver": 0,
    "priorcancer": 0,
    "quit_smoking": "false",
    "race": 0,
    "sex": "Male",
    "speceq": null,
    "stroke": 0,
    "years_quit": null,
    "years_smoked": 60
}
</pre>

Which results in the following response payload:

<pre>
{
    "risk": 0.193,
    "deaths_no_screening": 155,
    "deaths_screening": 124,
    "lives_saved": 31,
    "days_gained": 61.11669518938028,
    "number_needed_to_screen": 32.0,
    "life_expectancy_without_screening": 7.564335568606437,
    "number_diagnosed": 193,
    "lcrisks_result_5years": {
        "Counterfactual: Years of life gained if lung cancer is found early due to screening": 0.7711193124115826,
        "False-positive CT lung screens per 1000": 484.26264188289804,
        "Screening increase lung cancer diagnosis per 1000": 23.93885816336666,
        "Counterfactual: Life-expectancy with 3 rounds of CT lung screens": 7.7316639606375945,
        "Years of life gained if lung cancer is found early due to screening": 0.7711193124115826,
        "Number of lung cancer deaths per 1000 (LCDRAT)": 155.53553890015905,
        "Number of years predictions are for": 10,
        "Number with lung cancer diagnosed per 1000 (LCRAT)": 193.0553077690857,
        "Counterfactual: Life-expectancy without CT lung screens": 7.564335568606437,
        "Days of life gained from undergoing 3 rounds of CT lung screens": 61.11669518938028,
        "Screening reduced lung cancer deaths per 1000": 31.72924993563245,
        "Life-expectancy with 3 rounds of CT lung screens": 7.7316639606375945,
        "Years of life gained if lung cancer death is averted due to screening": 5.273632133460712,
        "Counterfactual: Years of life gained if lung cancer death is averted due to screening": 5.273632133460712,
        "Counterfactual: Days of life gained from undergoing 3 rounds of CT lung screens": 61.11669518938028,
        "Life-expectancy without CT lung screens": 7.564335568606437,
        "USPSTF eligible": 1.0
    }
}</pre>
