function setError(msg) {
  const el = document.querySelector("#mailbrew-error-message");
  el.innerText = msg;
}

function setSuccess(msg) {
  const el = document.querySelector("#mailbrew-success-message");
  el.innerText = msg;
}

const form = document.querySelector("#mailbrew-embed-form");

form.addEventListener("submit", function (event) {
  event.preventDefault();
  const email = form.querySelector("input[name='email']").value;
  const brewID = form.querySelector("input[name='id']").value;

  setError("");
  setSuccess("");

  fetch("https://api.mailbrew.com/brew_public_subscribe/", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email: email, share_id: brewID }),
  }).then((res) => {
    // error
    if (res.status !== 200) {
      res.json().then((json) => {
        setError(json.detail);
      });
    }
    // success
    else {
      setSuccess("Done! Please check your inbox for confirmation.");
    }
  });
});
