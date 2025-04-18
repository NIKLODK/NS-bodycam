window.addEventListener('message', function (event) {
    const data = event.data;
  
    if (data.type === 'startRecording') {
      document.getElementById('bodycam').classList.remove('hidden');
      document.getElementById('badge').innerText = `Badge: ${data.badge}`;
      document.getElementById('datetime').innerText = `${data.date} - ${data.time}`;
      document.getElementById('unit').innerText = `${data.unit} ${data.id}`;
    }
  
    if (data.type === 'stopRecording') {
      document.getElementById('bodycam').classList.add('hidden');
    }
  });
  