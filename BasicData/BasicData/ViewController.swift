import UIKit
import Security

struct AppTheme {
    let name: String
    let gradient: [CGColor]
    let button: [CGColor]
    let accent: UIColor
}

let themes: [AppTheme] = [
    AppTheme(name: "Purple",
             gradient: [UIColor(red:0.55,green:0.10,blue:0.75,alpha:1).cgColor,
                        UIColor(red:0.10,green:0.20,blue:0.80,alpha:1).cgColor,
                        UIColor(red:0.05,green:0.60,blue:0.70,alpha:1).cgColor],
             button: [UIColor(red:1.00,green:0.35,blue:0.55,alpha:1).cgColor,
                      UIColor(red:0.55,green:0.10,blue:0.95,alpha:1).cgColor],
             accent: UIColor(red:1.00,green:0.35,blue:0.55,alpha:1)),

    AppTheme(name: "Sunset",
             gradient: [UIColor(red:0.75,green:0.22,blue:0.17,alpha:1).cgColor,
                        UIColor(red:0.90,green:0.49,blue:0.13,alpha:1).cgColor,
                        UIColor(red:0.95,green:0.76,blue:0.10,alpha:1).cgColor],
             button: [UIColor(red:0.95,green:0.50,blue:0.10,alpha:1).cgColor,
                      UIColor(red:0.75,green:0.20,blue:0.15,alpha:1).cgColor],
             accent: UIColor(red:0.95,green:0.50,blue:0.10,alpha:1)),

    AppTheme(name: "Ocean",
             gradient: [UIColor(red:0.10,green:0.23,blue:0.43,alpha:1).cgColor,
                        UIColor(red:0.08,green:0.40,blue:0.75,alpha:1).cgColor,
                        UIColor(red:0.00,green:0.60,blue:0.70,alpha:1).cgColor],
             button: [UIColor(red:0.00,green:0.65,blue:0.85,alpha:1).cgColor,
                      UIColor(red:0.08,green:0.35,blue:0.75,alpha:1).cgColor],
             accent: UIColor(red:0.00,green:0.65,blue:0.85,alpha:1)),

    AppTheme(name: "Forest",
             gradient: [UIColor(red:0.10,green:0.36,blue:0.20,alpha:1).cgColor,
                        UIColor(red:0.16,green:0.55,blue:0.40,alpha:1).cgColor,
                        UIColor(red:0.05,green:0.38,blue:0.45,alpha:1).cgColor],
             button: [UIColor(red:0.15,green:0.68,blue:0.38,alpha:1).cgColor,
                      UIColor(red:0.10,green:0.38,blue:0.25,alpha:1).cgColor],
             accent: UIColor(red:0.15,green:0.68,blue:0.38,alpha:1)),

    AppTheme(name: "Rose",
             gradient: [UIColor(red:0.53,green:0.06,blue:0.31,alpha:1).cgColor,
                        UIColor(red:0.48,green:0.12,blue:0.64,alpha:1).cgColor,
                        UIColor(red:0.27,green:0.15,blue:0.63,alpha:1).cgColor],
             button: [UIColor(red:0.91,green:0.12,blue:0.39,alpha:1).cgColor,
                      UIColor(red:0.48,green:0.12,blue:0.64,alpha:1).cgColor],
             accent: UIColor(red:0.91,green:0.12,blue:0.39,alpha:1))
]

// MARK: - LoginViewController

class LoginViewController: UIViewController {

    let bgLayer     = CAGradientLayer()
    let cardView    = UIView()
    let titleLbl    = UILabel()
    let subLbl      = UILabel()
    let userField   = UITextField()
    let passField   = UITextField()
    let remLbl      = UILabel()
    let remSwitch   = UISwitch()
    let saveBtn     = UIButton(type: .custom)
    let readBtn     = UIButton(type: .system)
    let settBtn     = UIButton(type: .system)
    let saveBtnGrad = CAGradientLayer()
    let resultLbl   = UILabel()

    var themeIndex  = 0
    var theme: AppTheme { themes[themeIndex] }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                   print("PLIST YOLU:", path.appendingPathComponent("Preferences").path)
               } 
        if let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                    print("PLIST YOLU:", path.appendingPathComponent("Preferences").path)
                } 

        themeIndex = UserDefaults.standard.integer(forKey: "theme")

        setupBG()
        setupCard()
        autoFill()

        let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"
        applyLanguage(isTR)

        let savedAppearance = UserDefaults.standard.string(forKey:"appearance") ?? "light"
        applyAppearance(savedAppearance == "dark" ? .dark : .light)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = view.bounds
        saveBtnGrad.frame = saveBtn.bounds
    }

    func setupBG() {
        bgLayer.colors = theme.gradient
        bgLayer.startPoint = CGPoint(x:0,y:0)
        bgLayer.endPoint = CGPoint(x:1,y:1)
        view.layer.insertSublayer(bgLayer, at:0)
    }

    func setupCard() {
        let sw = view.frame.width
        let sh = view.frame.height
        let cw = sw - 48
        let ch: CGFloat = 390
        let cx = (sw - cw) / 2
        let cy = (sh - ch) / 2 - 30

        cardView.frame = CGRect(x:cx,y:cy,width:cw,height:ch)
        cardView.layer.cornerRadius = 28
        cardView.layer.borderWidth = 1
        cardView.clipsToBounds = true
        view.addSubview(cardView)

        titleLbl.font = .systemFont(ofSize:26, weight:.bold)
        titleLbl.textAlignment = .center
        titleLbl.frame = CGRect(x:20,y:32,width:cw-40,height:34)
        cardView.addSubview(titleLbl)

        subLbl.font = .systemFont(ofSize:14)
        subLbl.textAlignment = .center
        subLbl.frame = CGRect(x:20,y:70,width:cw-40,height:20)
        cardView.addSubview(subLbl)

        addField(userField, ph:"Username", y:106, w:cw)
        addField(passField, ph:"Password", y:170, w:cw)
        passField.isSecureTextEntry = true

        remLbl.font = .systemFont(ofSize:14)
        remLbl.frame = CGRect(x:20,y:234,width:160,height:30)
        cardView.addSubview(remLbl)

        remSwitch.onTintColor = theme.accent
        remSwitch.isOn = UserDefaults.standard.bool(forKey:"rememberMe")
        remSwitch.frame = CGRect(x:cw-71,y:236,width:51,height:31)
        cardView.addSubview(remSwitch)

        saveBtn.frame = CGRect(x:20,y:284,width:cw-40,height:46)
        saveBtn.layer.cornerRadius = 23
        saveBtn.clipsToBounds = true
        saveBtn.setTitleColor(.white, for:.normal)
        saveBtn.titleLabel?.font = .systemFont(ofSize:16, weight:.semibold)
        saveBtn.addTarget(self, action:#selector(saveTapped), for:.touchUpInside)
        cardView.addSubview(saveBtn)

        saveBtnGrad.colors = theme.button
        saveBtnGrad.startPoint = CGPoint(x:0,y:0)
        saveBtnGrad.endPoint = CGPoint(x:1,y:1)
        saveBtn.layer.insertSublayer(saveBtnGrad, at:0)

        readBtn.titleLabel?.font = .systemFont(ofSize:13)
        readBtn.frame = CGRect(x:20,y:342,width:cw-40,height:36)
        readBtn.addTarget(self, action:#selector(readTapped), for:.touchUpInside)
        cardView.addSubview(readBtn)

        resultLbl.frame = CGRect(x:cx,y:cy+ch+14,width:cw,height:40)
        resultLbl.textAlignment = .center
        resultLbl.font = .systemFont(ofSize:13, weight:.medium)
        resultLbl.numberOfLines = 2
        resultLbl.alpha = 0
        view.addSubview(resultLbl)

        settBtn.frame = CGRect(x:(sw-140)/2,y:cy+ch+62,width:140,height:36)
        settBtn.addTarget(self, action:#selector(openSettings), for:.touchUpInside)
        view.addSubview(settBtn)
    }

    func addField(_ f: UITextField, ph: String, y: CGFloat, w: CGFloat) {
        f.layer.cornerRadius = 14
        f.layer.borderWidth = 1
        f.leftView = UIView(frame:CGRect(x:0,y:0,width:16,height:52))
        f.leftViewMode = .always
        f.clipsToBounds = true
        f.frame = CGRect(x:20,y:y,width:w-40,height:52)
        cardView.addSubview(f)
    }

    func applyAppearance(_ style: UIUserInterfaceStyle) {
        overrideUserInterfaceStyle = style

        let isDark = style == .dark

        cardView.backgroundColor = isDark
        ? UIColor.black.withAlphaComponent(0.32)
        : UIColor.white.withAlphaComponent(0.13)

        cardView.layer.borderColor = isDark
        ? UIColor.white.withAlphaComponent(0.12).cgColor
        : UIColor.white.withAlphaComponent(0.25).cgColor

        let mainText = UIColor.white
        let softText = UIColor.white.withAlphaComponent(isDark ? 0.55 : 0.70)
        let fieldBg = isDark
        ? UIColor.black.withAlphaComponent(0.28)
        : UIColor.white.withAlphaComponent(0.12)

        [titleLbl, resultLbl].forEach {
            $0.textColor = mainText
        }

        [subLbl, remLbl].forEach {
            $0.textColor = softText
        }

        [readBtn, settBtn].forEach {
            $0.setTitleColor(softText, for:.normal)
        }

        [userField, passField].forEach {
            $0.textColor = .white
            $0.backgroundColor = fieldBg
            $0.layer.borderColor = UIColor.white.withAlphaComponent(isDark ? 0.10 : 0.20).cgColor
        }

        refreshPlaceholders()

        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
            self.view.layoutIfNeeded()
        }
    }

    func refreshPlaceholders() {
        let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"

        userField.attributedPlaceholder = NSAttributedString(
            string: isTR ? "Kullanıcı adı" : "Username",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.45)]
        )

        passField.attributedPlaceholder = NSAttributedString(
            string: isTR ? "Şifre" : "Password",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.45)]
        )
    }

    func applyLanguage(_ isTR: Bool) {
        titleLbl.text = isTR ? "Tekrar hoş geldin" : "Welcome back"
        subLbl.text = isTR ? "Devam etmek için giriş yap" : "Sign in to continue"
        remLbl.text = isTR ? "Beni hatırla" : "Remember me"
        saveBtn.setTitle(isTR ? "Kaydet ve Giriş Yap" : "Save & Login", for:.normal)
        readBtn.setTitle(isTR ? "Veriyi Oku" : "Read Data", for:.normal)
        settBtn.setTitle(isTR ? "Ayarlar" : "Settings", for:.normal)
        refreshPlaceholders()
    }

    func flash(_ msg: String) {
        resultLbl.text = msg

        UIView.animate(withDuration:0.3) {
            self.resultLbl.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline:.now()+3) {
            UIView.animate(withDuration:0.3) {
                self.resultLbl.alpha = 0
            }
        }
    }

    func autoFill() {
        guard UserDefaults.standard.bool(forKey:"rememberMe") else { return }

        userField.text = UserDefaults.standard.string(forKey:"username") ?? ""
        passField.text = kcRead("password") ?? ""
    }

    @objc func saveTapped() {
        let u = userField.text?.trimmingCharacters(in:.whitespaces) ?? ""
        let p = passField.text ?? ""

        guard !u.isEmpty, !p.isEmpty else { return }

        UIView.animate(withDuration:0.1, animations:{
            self.saveBtn.transform = CGAffineTransform(scaleX:0.96,y:0.96)
        }) { _ in
            UIView.animate(withDuration:0.1) {
                self.saveBtn.transform = .identity
            }
        }

        UserDefaults.standard.set(u, forKey:"username")
        UserDefaults.standard.set(remSwitch.isOn, forKey:"rememberMe")

        if remSwitch.isOn {
            kcSave("password", value:p)
        } else {
            kcDelete("password")
        }

        let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"
        flash(isTR ? "Bilgiler kaydedildi" : "Data saved")
    }

    @objc func readTapped() {
        let u = UserDefaults.standard.string(forKey:"username") ?? "—"
        let p = kcRead("password") != nil ? "******" : "—"
        flash("\(u)   \(p)")
    }

    @objc func openSettings() {
        let vc = SettingsViewController()
        vc.loginVC = self
        vc.themeIndex = themeIndex
        vc.modalPresentationStyle = .formSheet
        present(vc, animated:true)
    }

    func kcSave(_ key: String, value: String) {
        guard let d = value.data(using:.utf8) else { return }

        let q: [String:Any] = [
            kSecClass as String:kSecClassGenericPassword,
            kSecAttrAccount as String:key,
            kSecValueData as String:d
        ]

        SecItemDelete(q as CFDictionary)
        SecItemAdd(q as CFDictionary, nil)
    }

    func kcRead(_ key: String) -> String? {
        let q: [String:Any] = [
            kSecClass as String:kSecClassGenericPassword,
            kSecAttrAccount as String:key,
            kSecReturnData as String:true,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var r: AnyObject?
        SecItemCopyMatching(q as CFDictionary, &r)

        return (r as? Data).flatMap {
            String(data:$0, encoding:.utf8)
        }
    }

    func kcDelete(_ key: String) {
        SecItemDelete([
            kSecClass as String:kSecClassGenericPassword,
            kSecAttrAccount as String:key
        ] as CFDictionary)
    }
}

// MARK: - SettingsViewController

class SettingsViewController: UIViewController {

    weak var loginVC: LoginViewController?
    var themeIndex = 0

    let bgLayer = CAGradientLayer()

    var swatches = [UIButton]()
    var langBtns = [UIButton]()
    var appearBtns = [UIButton]()
    var cards = [UIView]()
    var sectionLabels = [UILabel]()

    let titleLbl = UILabel()
    let closeBtn = UIButton(type:.system)

    override func viewDidLoad() {
        super.viewDidLoad()

        bgLayer.colors = themes[themeIndex].gradient
        bgLayer.startPoint = CGPoint(x:0,y:0)
        bgLayer.endPoint = CGPoint(x:1,y:1)
        view.layer.insertSublayer(bgLayer, at:0)

        buildUI()

        let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"
        applySettingsLanguage(isTR)

        let savedAppearance = UserDefaults.standard.string(forKey:"appearance") ?? "light"
        applyAppearance(savedAppearance == "dark" ? .dark : .light)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = view.bounds
    }

    func buildUI() {
        let sw = view.frame.width
        let cw = sw - 48
        let cx = (sw - cw) / 2

        titleLbl.font = .systemFont(ofSize:24, weight:.bold)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.frame = CGRect(x:20,y:40,width:sw-40,height:34)
        view.addSubview(titleLbl)

        closeBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for:.normal)
        closeBtn.frame = CGRect(x:sw-80,y:44,width:70,height:28)
        closeBtn.addTarget(self, action:#selector(closeTapped), for:.touchUpInside)
        view.addSubview(closeBtn)

        makeCard(y:96, h:155, cw:cw, cx:cx) { card in
            self.secLabel("TEMA", to:card, y:18, cw:cw)

            let sz: CGFloat = 48
            let gap = (cw - 40 - sz * CGFloat(themes.count)) / CGFloat(themes.count - 1)

            for (i,t) in themes.enumerated() {
                let btn = UIButton(type:.custom)
                let x = 20 + CGFloat(i) * (sz + gap)

                btn.frame = CGRect(x:x,y:46,width:sz,height:sz)
                btn.layer.cornerRadius = 14
                btn.clipsToBounds = true
                btn.tag = i

                let g = CAGradientLayer()
                g.colors = t.button
                g.frame = CGRect(x:0,y:0,width:sz,height:sz)
                btn.layer.addSublayer(g)

                if i == self.themeIndex {
                    self.selectSwatch(btn, sz:sz)
                }

                let nm = UILabel()
                nm.text = t.name
                nm.font = .systemFont(ofSize:9)
                nm.textColor = UIColor.white.withAlphaComponent(0.6)
                nm.textAlignment = .center
                nm.frame = CGRect(x:x-4,y:102,width:sz+8,height:14)
                card.addSubview(nm)

                btn.addTarget(self, action:#selector(self.swatchTapped(_:)), for:.touchUpInside)
                card.addSubview(btn)
                self.swatches.append(btn)
            }
        }

        makeCard(y:265, h:100, cw:cw, cx:cx) { card in
            self.secLabel("DIL / LANGUAGE", to:card, y:18, cw:cw)

            let bw = (cw - 52) / 2

            let tr = self.optBtn("Türkçe", x:20, y:46, w:bw, tag:0)
            let en = self.optBtn("English", x:20+bw+12, y:46, w:bw, tag:1)

            tr.addTarget(self, action:#selector(self.langTapped(_:)), for:.touchUpInside)
            en.addTarget(self, action:#selector(self.langTapped(_:)), for:.touchUpInside)

            let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"
            self.setActive(isTR ? tr : en, group:[tr,en])

            self.langBtns = [tr,en]
            card.addSubview(tr)
            card.addSubview(en)
        }

        makeCard(y:379, h:100, cw:cw, cx:cx) { card in
            self.secLabel("GORUNUM / APPEARANCE", to:card, y:18, cw:cw)

            let bw = (cw - 52) / 2

            let lt = self.optBtn("Light", x:20, y:46, w:bw, tag:0)
            let dk = self.optBtn("Dark", x:20+bw+12, y:46, w:bw, tag:1)

            lt.addTarget(self, action:#selector(self.appearTapped(_:)), for:.touchUpInside)
            dk.addTarget(self, action:#selector(self.appearTapped(_:)), for:.touchUpInside)

            let savedAppearance = UserDefaults.standard.string(forKey:"appearance") ?? "light"
            self.setActive(savedAppearance == "dark" ? dk : lt, group:[lt,dk])

            self.appearBtns = [lt,dk]
            card.addSubview(lt)
            card.addSubview(dk)
        }

        makeCard(y:493, h:90, cw:cw, cx:cx) { card in
            self.secLabel("SIMULASYON", to:card, y:18, cw:cw)

            let del = self.simBtn("Verileri Temizle",
                                  color:UIColor(red:0.85,green:0.2,blue:0.2,alpha:0.75),
                                  x:20,y:44,w:cw-40)

            del.addTarget(self, action:#selector(self.deleteTapped), for:.touchUpInside)

            card.addSubview(del)
        }
    }

    func makeCard(y: CGFloat, h: CGFloat, cw: CGFloat, cx: CGFloat, config: (UIView)->Void) {
        let card = UIView(frame:CGRect(x:cx,y:y,width:cw,height:h))
        card.layer.cornerRadius = 22
        card.layer.borderWidth = 1
        config(card)
        view.addSubview(card)
        cards.append(card)
    }

    func secLabel(_ text: String, to parent: UIView, y: CGFloat, cw: CGFloat) {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize:10, weight:.semibold)
        l.frame = CGRect(x:20,y:y,width:cw-40,height:16)
        parent.addSubview(l)
        sectionLabels.append(l)
    }

    func optBtn(_ title: String, x: CGFloat, y: CGFloat, w: CGFloat, tag: Int) -> UIButton {
        let btn = UIButton(type:.custom)
        btn.setTitle(title, for:.normal)
        btn.titleLabel?.font = .systemFont(ofSize:13, weight:.medium)
        btn.frame = CGRect(x:x,y:y,width:w,height:36)
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        btn.tag = tag
        return btn
    }

    func setActive(_ active: UIButton, group: [UIButton]) {
        let isDark = UserDefaults.standard.string(forKey:"appearance") == "dark"

        group.forEach {
            $0.backgroundColor = isDark
            ? UIColor.black.withAlphaComponent(0.25)
            : UIColor.white.withAlphaComponent(0.1)

            $0.layer.borderColor = UIColor.white.withAlphaComponent(isDark ? 0.10 : 0.15).cgColor
            $0.setTitleColor(UIColor.white.withAlphaComponent(0.6), for:.normal)
        }

        active.backgroundColor = UIColor.white.withAlphaComponent(isDark ? 0.22 : 0.3)
        active.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        active.setTitleColor(.white, for:.normal)
    }

    func applyAppearance(_ style: UIUserInterfaceStyle) {
        overrideUserInterfaceStyle = style

        let isDark = style == .dark

        cards.forEach {
            $0.backgroundColor = isDark
            ? UIColor.black.withAlphaComponent(0.32)
            : UIColor.white.withAlphaComponent(0.13)

            $0.layer.borderColor = isDark
            ? UIColor.white.withAlphaComponent(0.12).cgColor
            : UIColor.white.withAlphaComponent(0.22).cgColor
        }

        titleLbl.textColor = .white
        closeBtn.setTitleColor(UIColor.white.withAlphaComponent(isDark ? 0.55 : 0.7), for:.normal)

        sectionLabels.forEach {
            $0.textColor = UIColor.white.withAlphaComponent(isDark ? 0.45 : 0.5)
        }

        if !langBtns.isEmpty {
            let isTR = UserDefaults.standard.string(forKey:"appLanguage") != "en"
            setActive(isTR ? langBtns[0] : langBtns[1], group:langBtns)
        }

        if !appearBtns.isEmpty {
            setActive(style == .dark ? appearBtns[1] : appearBtns[0], group:appearBtns)
        }

        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
            self.view.layoutIfNeeded()
        }
    }

    func simBtn(_ title: String, color: UIColor, x: CGFloat, y: CGFloat, w: CGFloat) -> UIButton {
        let btn = UIButton(type:.custom)
        btn.setTitle(title, for:.normal)
        btn.setTitleColor(.white, for:.normal)
        btn.titleLabel?.font = .systemFont(ofSize:14, weight:.semibold)
        btn.frame = CGRect(x:x,y:y,width:w,height:36)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = color
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return btn
    }

    func selectSwatch(_ btn: UIButton, sz: CGFloat) {
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.white.cgColor

        let c = UILabel()
        c.text = "✓"
        c.tag = 999
        c.font = .systemFont(ofSize:18, weight:.bold)
        c.textColor = .white
        c.textAlignment = .center
        c.frame = CGRect(x:0,y:0,width:sz,height:sz)
        btn.addSubview(c)
    }

    func applySettingsLanguage(_ isTR: Bool) {
        titleLbl.text = isTR ? "Ayarlar" : "Settings"
        closeBtn.setTitle(isTR ? "Kapat" : "Close", for:.normal)
    }

    @objc func swatchTapped(_ sender: UIButton) {
        swatches.forEach {
            $0.layer.borderWidth = 0
            $0.viewWithTag(999)?.removeFromSuperview()
        }

        selectSwatch(sender, sz:sender.frame.width)

        let i = sender.tag
        themeIndex = i
        UserDefaults.standard.set(i, forKey:"theme")

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        bgLayer.colors = themes[i].gradient
        CATransaction.commit()

        if let lvc = loginVC {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.4)
            lvc.bgLayer.colors = themes[i].gradient
            lvc.saveBtnGrad.colors = themes[i].button
            CATransaction.commit()

            lvc.remSwitch.onTintColor = themes[i].accent
            lvc.themeIndex = i
        }
    }

    @objc func langTapped(_ sender: UIButton) {
        setActive(sender, group:langBtns)

        let isTR = sender.tag == 0
        UserDefaults.standard.set(isTR ? "tr" : "en", forKey:"appLanguage")

        applySettingsLanguage(isTR)
        loginVC?.applyLanguage(isTR)
    }

    @objc func appearTapped(_ sender: UIButton) {
        let isDark = sender.tag == 1
        let style: UIUserInterfaceStyle = isDark ? .dark : .light

        UserDefaults.standard.set(isDark ? "dark" : "light", forKey:"appearance")

        setActive(sender, group:appearBtns)

        applyAppearance(style)
        loginVC?.applyAppearance(style)

        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                window.overrideUserInterfaceStyle = style
            }
    }

    @objc func deleteTapped() {
        ["username","rememberMe","theme","appLanguage","appearance"].forEach {
            UserDefaults.standard.removeObject(forKey:$0)
        }

        swatches.forEach {
            $0.layer.borderWidth = 0
            $0.viewWithTag(999)?.removeFromSuperview()
        }

        if let first = swatches.first {
            selectSwatch(first, sz:first.frame.width)
        }

        themeIndex = 0

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        bgLayer.colors = themes[0].gradient
        CATransaction.commit()

        setActive(langBtns[0], group:langBtns)
        setActive(appearBtns[0], group:appearBtns)

        applyAppearance(.light)

        if let lvc = loginVC {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.4)
            lvc.bgLayer.colors = themes[0].gradient
            lvc.saveBtnGrad.colors = themes[0].button
            CATransaction.commit()

            lvc.remSwitch.onTintColor = themes[0].accent
            lvc.themeIndex = 0
            lvc.userField.text = ""
            lvc.passField.text = ""
            lvc.applyLanguage(true)
            lvc.applyAppearance(.light)
        }

        applySettingsLanguage(true)

        let a = UIAlertController(title:"Veriler Temizlendi", message:nil, preferredStyle:.alert)
        a.addAction(UIAlertAction(title:"OK", style:.default))
        present(a, animated:true)
    }

    @objc func closeTapped() {
        dismiss(animated:true)
    }
}
