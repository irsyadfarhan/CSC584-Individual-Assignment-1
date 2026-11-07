<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    // Safe output: handles null and escapes HTML so user input cannot inject scripts
    private static String esc(Object o) {
        if (o == null) return "";
        String s = o.toString();
        StringBuilder sb = new StringBuilder(s.length());
        for (char c : s.toCharArray()) {
            switch (c) {
                case '&':  sb.append("&amp;");  break;
                case '<':  sb.append("&lt;");   break;
                case '>':  sb.append("&gt;");   break;
                case '"':  sb.append("&quot;"); break;
                case '\'': sb.append("&#39;");  break;
                default:   sb.append(c);
            }
        }
        return sb.toString();
    }
%>
<%
    String name         = esc(request.getAttribute("name"));
    String studentId    = esc(request.getAttribute("studentId"));
    String programme    = esc(request.getAttribute("programme"));
    String email        = esc(request.getAttribute("email"));
    String hobbies      = esc(request.getAttribute("hobbies"));
    String introduction = esc(request.getAttribute("introduction"));
    String initial      = name.isEmpty() ? "?" : name.substring(0, 1).toUpperCase();
    String[] hobbyList  = hobbies.isEmpty() ? new String[0] : hobbies.split("\\s*,\\s*");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= name %> | Student Profile</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; padding: 40px 16px;
            font-family: "Plus Jakarta Sans", "Segoe UI", Roboto, Arial, sans-serif;
            background: #f2f2f2; color: #14141a;
            display: flex; align-items: center; justify-content: center;
        }
        .shell {
            width: 100%; max-width: 940px; background: #ffffff; border-radius: 30px; box-shadow: 0 24px 60px rgba(0,0,0,.09), 0 2px 6px rgba(0,0,0,.04);
            display: grid; grid-template-columns: .85fr 1.15fr; overflow: hidden; animation: rise .5s ease;
        }
        @keyframes rise { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: none; } }

        /* LEFT: art + identity */
        .art-side {
            position: relative; overflow: hidden; padding: 44px 28px; text-align: center;
            background: linear-gradient(160deg, #f7f8f7 0%, #e9ecea 100%);
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .circle { position: absolute; border-radius: 50%; border: 2px solid rgba(255,255,255,.9);
            background: radial-gradient(circle at 30% 25%, rgba(255,255,255,.75), rgba(200,206,203,.35));
            box-shadow: inset 0 0 40px rgba(255,255,255,.7), 0 10px 40px rgba(0,0,0,.06); }
        .c1 { width: 340px; height: 340px; top: -120px; left: -110px; }
        .c2 { width: 400px; height: 400px; bottom: -180px; right: -140px; }
        .c3 { width: 240px; height: 240px; top: 45%; left: -120px; }
        .ident { position: relative; z-index: 1; }
        .avatar {
            width: 104px; height: 104px; margin: 0 auto 16px; border-radius: 50%; background: #14141a; color: #9dff2f;
            font-size: 2.9rem; font-weight: 800; display: flex; align-items: center; justify-content: center;
            box-shadow: 0 14px 30px rgba(0,0,0,.22);
        }
        .ident h2 { margin: 0; font-size: 1.55rem; font-weight: 800; letter-spacing: -.03em; word-break: break-word; }
        .ident p { margin: 6px 0 14px; color: #6f7378; font-size: .9rem; }
        .badge { display: inline-block; background: #fff; box-shadow: 0 6px 16px rgba(0,0,0,.07); padding: 5px 16px; border-radius: 99px; font-size: .8rem; font-weight: 700; }

        /* RIGHT: details */
        .info-side { padding: 44px 44px 36px; }
        .logo-star { font-size: 20px; line-height: 1; color: #14141a; }
        .logo { width: 38px; height: 38px; border: 2px solid #14141a; border-radius: 4px; display: flex; align-items: center; justify-content: center; margin-bottom: 14px; }
        .info-side h1 { margin: 0 0 6px; font-size: 1.8rem; font-weight: 800; letter-spacing: -.03em; }
        .lead { margin: 0 0 14px; color: #6f7378; font-size: .88rem; }
        .row { padding: 14px 0; border-top: 1px solid #e8e8e8; }
        .label { display: block; font-size: .72rem; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: #6f7378; margin-bottom: 5px; }
        .value { font-weight: 600; word-break: break-word; }
        .value a { color: #14141a; text-decoration: none; border-bottom: 1px solid #14141a; }
        .value a:hover { border-bottom-width: 2px; }
        .tag { display: inline-block; background: #fff; border: 1px solid #e8e8e8; box-shadow: 0 6px 16px rgba(0,0,0,.07); padding: 3px 13px; border-radius: 99px; font-size: .84rem; font-weight: 600; margin: 0 6px 6px 0; }
        .intro-box { margin-top: 2px; padding: 14px 16px; background: #f4f4f4; border-radius: 14px; line-height: 1.65; font-weight: 500; font-size: .92rem; white-space: pre-wrap; }

        .actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 12px; padding-top: 18px; border-top: 1px solid #e8e8e8; }
        .btn {
            flex: 1; min-width: 120px; text-align: center; padding: 13px 14px; font: inherit; font-weight: 800; font-size: .9rem;
            color: #14141a; border: none; border-radius: 12px; cursor: pointer; text-decoration: none; transition: transform .15s, box-shadow .2s, background .2s;
        }
        .btn-lime { background: #9dff2f; box-shadow: 0 8px 20px rgba(157,255,47,.5), 0 2px 4px rgba(0,0,0,.08); }
        .btn-lime:hover { background: #8aeb1a; transform: translateY(-2px); }
        .btn-white { background: #fff; box-shadow: 0 6px 16px rgba(0,0,0,.07), 0 0 0 1px #e8e8e8; }
        .btn-white:hover { transform: translateY(-2px); box-shadow: 0 10px 22px rgba(0,0,0,.1), 0 0 0 1px #e8e8e8; }

        .toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%) translateY(80px); background: #14141a; color: #fff; padding: 11px 22px; border-radius: 12px; opacity: 0; transition: all .3s; font-size: .88rem; font-weight: 600; }
        .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

        @media (max-width: 800px) {
            .shell { grid-template-columns: 1fr; }
            .art-side { padding: 34px 20px; }
            .info-side { padding: 30px 24px; }
        }
        @media print {
            body { background: #fff; padding: 0; }
            .shell { box-shadow: none; }
            .actions, .toast { display: none; }
        }
    </style>
</head>
<body>

<div class="shell">

    <aside class="art-side">
        <div class="circle c1"></div><div class="circle c2"></div><div class="circle c3"></div>
        <div class="ident">
            <div class="avatar"><%= initial %></div>
            <h2 id="pName"><%= name %></h2>
            <p><%= programme %></p>
            <span class="badge">ID: <%= studentId %></span>
        </div>
    </aside>

    <section class="info-side">
        <div class="logo">
            <span class="logo-star">&#10022;</span>
        </div>
        <h1>Student Profile</h1>
        <p class="lead">Your profile was submitted successfully.</p>

        <div class="row">
            <span class="label">Student ID</span>
            <span class="value" id="pId"><%= studentId %></span>
        </div>
        <div class="row">
            <span class="label">Programme</span>
            <span class="value" id="pProg"><%= programme %></span>
        </div>
        <div class="row">
            <span class="label">Email Address</span>
            <span class="value"><a href="mailto:<%= email %>" id="pEmail"><%= email %></a></span>
        </div>
        <div class="row">
            <span class="label">Hobbies</span>
            <span class="value" id="pHob">
                <% for (String h : hobbyList) { if (!h.isEmpty()) { %>
                    <span class="tag"><%= h %></span>
                <% } } %>
            </span>
        </div>
        <div class="row">
            <span class="label">Self Introduction</span>
            <div class="intro-box" id="pIntro"><%= introduction %></div>
        </div>

        <div class="actions">
            <a href="index.html" class="btn btn-lime">&laquo; Back to Form</a>
            <button type="button" class="btn btn-white" id="copyBtn">Copy Profile</button>
            <button type="button" class="btn btn-white" onclick="window.print()">Print</button>
        </div>
    </section>
</div>

<div class="toast" id="toast"></div>

<script>
(function () {
    var $ = function (id) { return document.getElementById(id); };

    function toast(msg) {
        var t = $('toast'); t.textContent = msg; t.classList.add('show');
        setTimeout(function () { t.classList.remove('show'); }, 2000);
    }

    $('copyBtn').addEventListener('click', function () {
        var hobbies = Array.prototype.map.call(document.querySelectorAll('#pHob .tag'), function (t) { return t.textContent; }).join(', ');
        var text =
            'Name: ' + $('pName').textContent + '\n' +
            'Student ID: ' + $('pId').textContent + '\n' +
            'Programme: ' + $('pProg').textContent + '\n' +
            'Email: ' + $('pEmail').textContent + '\n' +
            'Hobbies: ' + hobbies + '\n' +
            'Introduction: ' + $('pIntro').textContent.trim();
        function fallback() {
            var ta = document.createElement('textarea'); ta.value = text; document.body.appendChild(ta);
            ta.select(); try { document.execCommand('copy'); toast('Profile copied!'); } catch (e) { toast('Copy failed'); }
            document.body.removeChild(ta);
        }
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text).then(function () { toast('Profile copied!'); }, fallback);
        } else { fallback(); }
    });
})();
</script>
</body>
</html>
