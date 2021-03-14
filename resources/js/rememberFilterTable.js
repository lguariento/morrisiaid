if (window.location.pathname.includes('index.html')) {
    $(document).ready(function () {
        document.getElementById('searchPeFrom').addEventListener("change", function () {
            sessionStorage.setItem('searchPeFrom', document.getElementById('searchPeFrom').value)
        })
        document.getElementById('searchPeTo').addEventListener("change", function () {
            sessionStorage.setItem('searchPeTo', document.getElementById('searchPeTo').value)
        })
        document.getElementById('searchPlFrom').addEventListener("change", function () {
            sessionStorage.setItem('searchPlFrom', document.getElementById('searchPlFrom').value)
        })
        document.getElementById('searchPlTo').addEventListener("change", function () {
            sessionStorage.setItem('searchPlTo', document.getElementById('searchPlTo').value)
        })
        
        if (sessionStorage.getItem('searchPeFrom') != document.getElementById('searchPeFrom').value) {
            document.getElementById('searchPeFrom').value = sessionStorage.getItem('searchPeFrom')
        }
        
        if (sessionStorage.getItem('searchPeTo') != document.getElementById('searchPeTo').value) {
            document.getElementById('searchPeTo').value = sessionStorage.getItem('searchPeTo')
        }
        
        if (sessionStorage.getItem('searchPlFrom') != document.getElementById('searchPlFrom').value) {
            document.getElementById('searchPlFrom').value = sessionStorage.getItem('searchPlFrom')
        }
        
        if (sessionStorage.getItem('searchPlTo') != document.getElementById('searchPlTo').value) {
            document.getElementById('searchPlTo').value = sessionStorage.getItem('searchPlTo')
        }
    })
}