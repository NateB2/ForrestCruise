function confirmUserDelete(id) {
  if (confirm('Are you sure? This action cannot be undone.')) {
    window.open('/users/' + id + '/delete', '_self');
  }
}
