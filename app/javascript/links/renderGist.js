const { Octokit } = require("@octokit/rest")

const octokit = new Octokit({
  baseUrl: 'https://api.github.com',
})

const GIST_REGEX = /^https:\/\/gist.github.com\//

function buildHTML(data) {
  let HTML = ''
  let links = Object.values(data.files).map((file) => {
    return `
      <div class="file">
        <p>${file.filename}</p>
        <code>${file.content}</code>
      </div>
    `
  })

  links.forEach((link) => {
    HTML = HTML.concat(link)
  })
  return HTML
}

function renderGistData(data, domLink) {
  const HTML = buildHTML(data)
  domLink.parentElement.innerHTML = `<div class='gist'>${HTML}</div>`
}

function gistData(gist_id, domLink) {
  let gist = octokit.gists.get({
    gist_id,
  })

  gist.then(
    payload => renderGistData(payload.data, domLink),
    error => console.log(error)
  );
}

function findGistLinks() {
  let linkTags = document.querySelectorAll('.link a')
  linkTags.forEach((domLink) => {
    let link = domLink.href
    if (link.match(GIST_REGEX)) {
      let buff = link.split('/')
      let gist_id = buff[buff.length - 1]
      gistData(gist_id, domLink)
    }
  })
}

document.addEventListener('gist:updated', function() {
  findGistLinks()
});

document.addEventListener('turbolinks:load', function() {
  findGistLinks()
});
