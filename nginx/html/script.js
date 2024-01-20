document.addEventListener('DOMContentLoaded', function() {
    // 初始化时从服务器获取配置数据并填充表单
    fetch('getConfig.php')
        .then(response => response.json())
        .then(data => {
            Object.keys(data).forEach(key => {
                const input = document.getElementById(key);
                if (input) {
                    input.value = data[key];
                }
            });
        })
        .catch(error => console.error('Error fetching config:', error));
});

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('redEnvelopeForm');
    form.addEventListener('submit', function(event) {
        event.preventDefault(); // 阻止表单的默认提交行为

        // 使用 FormData 来获取表单数据
        let formData = new FormData(form);

        // 发送 AJAX 请求
        fetch('submitConfig.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert('提交失败！' + data.message); // 显示错误弹窗
            } else {
                alert('提交成功！' + data.message); // 显示成功弹窗
            }
        })
        .catch(error => {
            alert('提交时发生其他错误。');
        });
    });
});

