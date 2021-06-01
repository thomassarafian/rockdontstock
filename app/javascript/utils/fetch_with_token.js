import { csrfToken } from "@rails/ujs";

const fetchWithToken = (url, options) => {
  options.headers = {
    "X-CSRF-Token": csrfToken()
  };

  return fetch(url, options);
}

export { fetchWithToken };
