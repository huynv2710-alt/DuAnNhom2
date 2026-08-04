function init34TinhThanhAddress(cityId, wardId, detailId, hiddenId) {
    let cityEl = document.getElementById(cityId);
    let wardEl = document.getElementById(wardId);
    let detailEl = document.getElementById(detailId);
    let hiddenEl = document.getElementById(hiddenId);
    
    if(!cityEl || !wardEl || !hiddenEl) return;

    fetch('https://provinces.open-api.vn/api/p/')
        .then(response => response.json())
        .then(data => {
            window.provincesCache = data;
            cityEl.innerHTML = '<option value="">-- Chọn Tỉnh Thành --</option>';
            data.forEach(city => {
                let opt = document.createElement('option');
                opt.value = city.name;
                opt.setAttribute('data-code', city.code);
                opt.textContent = city.name;
                cityEl.appendChild(opt);
            });

            autoSelectExistingAddress();
        })
        .catch(err => console.log('Error loading provinces: ', err));

    cityEl.addEventListener('change', function() {
        wardEl.innerHTML = '<option value="">-- Chọn Phường Xã --</option>';
        let selectedOption = cityEl.options[cityEl.selectedIndex];
        let code = selectedOption ? selectedOption.getAttribute('data-code') : null;
        
        if (code) {
            // Fetch depth=3 to get all districts and wards, then flatten all wards into the ward dropdown
            fetch('https://provinces.open-api.vn/api/p/' + code + '?depth=3')
                .then(response => response.json())
                .then(data => {
                    if (data.districts) {
                        data.districts.forEach(d => {
                            if (d.wards) {
                                d.wards.forEach(w => {
                                    let opt = document.createElement('option');
                                    opt.value = w.name;
                                    opt.setAttribute('data-code', w.code);
                                    opt.textContent = w.name + " (" + d.name + ")"; // Thêm tên quận/huyện để dễ phân biệt (tuỳ chọn)
                                    wardEl.appendChild(opt);
                                });
                            }
                        });
                    }
                })
                .catch(err => console.log('Error loading wards: ', err));
        }
        updateAddress();
    });

    wardEl.addEventListener('change', updateAddress);
    if(detailEl) detailEl.addEventListener('input', updateAddress);

    function updateAddress() {
        let city = cityEl.value;
        let ward = wardEl.value;
        let detail = detailEl ? detailEl.value : '';
        
        let parts = [];
        if (detail) parts.push(detail);
        if (ward) parts.push(ward);
        if (city) parts.push(city);
        
        hiddenEl.value = parts.join(', ');
    }
    
    function autoSelectExistingAddress() {
        let existingAddress = hiddenEl.value;
        if (!existingAddress || existingAddress.trim() === '') return;
        
        let parts = existingAddress.split(',').map(s => s.trim());
        if(parts.length > 0) {
            let foundCityCode = null;
            for(let i=0; i<window.provincesCache.length; i++) {
                let pName = window.provincesCache[i].name;
                if(parts.includes(pName) || (pName === 'Thành phố Hồ Chí Minh' && parts.includes('TP Hồ Chí Minh'))) {
                    cityEl.value = pName;
                    foundCityCode = window.provincesCache[i].code;
                    break;
                }
            }
            
            if(foundCityCode) {
                fetch('https://provinces.open-api.vn/api/p/' + foundCityCode + '?depth=3')
                    .then(response => response.json())
                    .then(data => {
                        wardEl.innerHTML = '<option value="">-- Chọn Phường Xã --</option>';
                        let allWards = [];
                        if(data.districts) {
                            data.districts.forEach(d => {
                                if(d.wards) {
                                    d.wards.forEach(w => {
                                        let opt = document.createElement('option');
                                        opt.value = w.name;
                                        opt.setAttribute('data-code', w.code);
                                        opt.textContent = w.name + " (" + d.name + ")";
                                        wardEl.appendChild(opt);
                                        allWards.push(w.name);
                                    });
                                }
                            });
                        }

                        for(let i=0; i<allWards.length; i++) {
                            if(parts.includes(allWards[i])) {
                                wardEl.value = allWards[i];
                                break;
                            }
                        }

                        if(detailEl) {
                            let detailParts = parts.filter(p => 
                                p !== cityEl.value && 
                                p !== wardEl.value && 
                                p !== 'TP Hồ Chí Minh' && 
                                p !== 'Thành phố Hồ Chí Minh'
                            );
                            detailEl.value = detailParts.join(', ');
                        }
                    })
                    .catch(err => console.log(err));
            } else if(detailEl) {
                detailEl.value = existingAddress;
            }
        }
    }
}

// Function for khachhang support if they call fillAddressData directly
window.fillAddressData = function(cityId, wardId, detailId, hiddenId, diaChi) {
    let hiddenEl = document.getElementById(hiddenId);
    if(hiddenEl) {
        hiddenEl.value = diaChi;
        init34TinhThanhAddress(cityId, wardId, detailId, hiddenId);
    }
};
