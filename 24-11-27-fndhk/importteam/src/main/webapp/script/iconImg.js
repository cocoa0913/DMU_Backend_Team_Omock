function submitForm(imageSrc, iconCode) {

	const currentIconImage = document.getElementById('currentIconImage');
	if (currentIconImage) {
	    currentIconImage.src = imageSrc; // 현재 아이콘 이미지 변경
	}
	
    // 해당 아이콘 코드의 라디오 버튼을 체크
    const radioButtons = document.getElementsByName('iconCode');
    radioButtons.forEach(radio => {
        if (radio.value === iconCode) {
            radio.checked = true;
        }
    });
	
	const formData = new FormData();
    formData.append('userCode', document.querySelector('input[name="userCode"]').value);
    formData.append('nickname', document.querySelector('input[name="nickname"]').value);
    formData.append('level', document.querySelector('input[name="level"]').value);
    formData.append('cash', document.querySelector('input[name="cash"]').value);
    formData.append('iconCode', iconCode);
    
	fetch('ChangeIconServlet', {
	        method: 'POST',
	        body: formData
	    })
	.then(response => response.json())
	.then(data => {
	    // 서버에서 받은 응답으로 아이콘을 갱신
	    const newIconSrc = data.newIconSrc;
	    if (newIconSrc) {
	        currentIconImage.src = newIconSrc;
	    }
	})
	.catch(error => console.error('Error:', error));
}