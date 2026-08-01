function init34TinhThanhAddress(cityId, wardId, detailId, hiddenId) {
    let cityEl = document.getElementById(cityId);
    let wardEl = document.getElementById(wardId);
    let detailEl = document.getElementById(detailId);
    let hiddenEl = document.getElementById(hiddenId);
    
    if(!cityEl || !wardEl || !hiddenEl) return;

    fetch('https://34tinhthanh.com/api/provinces')
        .then(response => response.json())
        .then(data => {
            window.provincesCache = data;
            cityEl.innerHTML = '<option value="">-- Chọn tỉnh/thành phố --</option>';
            data.forEach(city => {
                let opt = document.createElement('option');
                opt.value = city.name;
                opt.setAttribute('data-code', city.province_code);
                opt.textContent = city.name;
                cityEl.appendChild(opt);
            });

            autoSelectExistingAddress(data);
        })
        .catch(err => console.log('Error loading provinces: ', err));

    cityEl.addEventListener('change', function() {
        wardEl.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
        let selectedOption = cityEl.options[cityEl.selectedIndex];
        let code = selectedOption ? selectedOption.getAttribute('data-code') : null;
        
        if (code) {
            fetch('https://34tinhthanh.com/api/wards?province_code=' + code)
                .then(response => response.json())
                .then(wards => {
                    wards.forEach(w => {
                        let opt = document.createElement('option');
                        opt.value = w.ward_name;
                        opt.setAttribute('data-code', w.ward_code);
                        opt.textContent = w.ward_name;
                        wardEl.appendChild(opt);
                    });

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
    
    function autoSelectExistingAddress(provinces) {
        let existingAddress = hiddenEl.value;
        if (!existingAddress || existingAddress.trim() === '') return;
        
        let parts = existingAddress.split(',').map(s => s.trim());
        if(parts.length > 0) {
            let foundCityCode = null;
            for(let i=0; i<provinces.length; i++) {
                let pName = provinces[i].name;
                if(parts.includes(pName) || (pName === 'Thành phố Hồ Chí Minh' && parts.includes('TP Hồ Chí Minh'))) {
                    cityEl.value = pName;
                    foundCityCode = provinces[i].province_code;
                    break;
                }
            }
            
            if(foundCityCode) {
                fetch('https://34tinhthanh.com/api/wards?province_code=' + foundCityCode)
                    .then(response => response.json())
                    .then(wards => {
                        wardEl.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
                        wards.forEach(w => {
                            let opt = document.createElement('option');
                            opt.value = w.ward_name;
                            opt.setAttribute('data-code', w.ward_code);
                            opt.textContent = w.ward_name;
                            wardEl.appendChild(opt);
                        });

                        let foundWard = false;
                        for(let i=0; i<wards.length; i++) {
                            if(parts.includes(wards[i].ward_name)) {
                                wardEl.value = wards[i].ward_name;
                                foundWard = true;
                                break;
                            }
                        }
                        
                        if(detailEl) {
                            let detailParts = parts.filter(p => p !== cityEl.value && p !== wardEl.value && p !== 'TP Hồ Chí Minh' && p !== 'Thành phố Hồ Chí Minh');
                            detailEl.value = detailParts.join(', ');
                        }
                    })
                    .catch(err => console.log(err));
            } else if(detailEl) {
                detailEl.value = existingAddress;
            }
        }
    }
    
    window.fillAddressData = function(cId, wId, dId, hId, address) {
        if(!window.provincesCache) return;
        let cEl = document.getElementById(cId);
        let wEl = document.getElementById(wId);
        let dEl = document.getElementById(dId);
        
        if (!address || address.trim() === '') {
            if(dEl) dEl.value = '';
            cEl.value = '';
            wEl.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
            return;
        }
        
        let parts = address.split(',').map(s => s.trim());
        let foundCityCode = null;
        for(let i=0; i<window.provincesCache.length; i++) {
            let pName = window.provincesCache[i].name;
            if(parts.includes(pName) || (pName === 'Thành phố Hồ Chí Minh' && parts.includes('TP Hồ Chí Minh'))) {
                cEl.value = pName;
                foundCityCode = window.provincesCache[i].province_code;
                break;
            }
        }
        
        if(foundCityCode) {
            fetch('https://34tinhthanh.com/api/wards?province_code=' + foundCityCode)
                .then(response => response.json())
                .then(wards => {
                    wEl.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
                    wards.forEach(w => {
                        let opt = document.createElement('option');
                        opt.value = w.ward_name;
                        opt.setAttribute('data-code', w.ward_code);
                        opt.textContent = w.ward_name;
                        wEl.appendChild(opt);
                    });
                    
                    for(let i=0; i<wards.length; i++) {
                        if(parts.includes(wards[i].ward_name)) {
                            wEl.value = wards[i].ward_name;
                            break;
                        }
                    }
                    
                    if(dEl) {
                        let detailParts = parts.filter(p => p !== cEl.value && p !== wEl.value && p !== 'TP Hồ Chí Minh' && p !== 'Thành phố Hồ Chí Minh');
                        dEl.value = detailParts.join(', ');
                    }
                })
                .catch(err => console.log(err));
        } else if(dEl) {
            dEl.value = address;
        }
    };
}
