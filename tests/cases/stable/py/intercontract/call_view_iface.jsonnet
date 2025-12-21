local simple = import 'templates/two.jsonnet';
simple.run('${jsonnetDir}/call_view_from_iface.py', '${jsonnetDir}/call_view_to.py',
    |||
        {
            "method": "main",
            "args": [Address(toAddr)]
        }
    |||
)
