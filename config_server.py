#!/usr/bin/python3
'''Implement a simple templating HTTP server to generate customize Mikrotik
   client configurations for HamWAN.
'''
from datetime import datetime
from io import BytesIO
import re
import secrets
from flask import Flask, render_template, request, url_for, flash, redirect
from flask import send_file, send_from_directory

app = Flask(__name__)
with open('config_server.key', 'r') as file:
    app.config['SECRET_KEY'] = file.read().rstrip()

valid_url_re = re.compile(r'\A(config_form.html|template/[A-Za-z\.]+)\Z')
valid_call_re = re.compile(r'\A[A-Za-z]{1,2}\d[A-Za-z]{1,3}\Z')
valid_float_re = re.compile(r'\A[\d\-]{1,4}\.[\d]{1,10}\Z')
valid_location_re = re.compile(r'\A[\w\-]{1,32}\Z')
valid_password_re = re.compile(r'\A\S{8,64}\Z')
valid_ethernet_config_re = re.compile(r'\A(client|server)\Z')

def valid_string(pattern, s):
    '''Returns true if string s matches a pattern.'''
    return s and pattern.search(s)

def valid_float(s, lower, upper):
    '''Returns true if string s is a valid real number within a given range (inclusive).'''
    if s is None or not valid_float_re.search(s):
        return False
    try:
        f = float(s)
    except ValueError:
        return False
    return lower < f < upper

@app.route('/')
def root():
    '''Redirect to the configuration form.'''
    return redirect(url_for('config'))

@app.route('/favicon.ico')
def favicon():
    '''Handle /favicon.ico GETs.'''
    #return redirect('http://hamwan.org/favicon.ico')
    return send_file('templates/favicon.png', mimetype='image/png')

@app.route('/templates/<path:subpath>')
def templates(subpath):
    '''Handle /templates GETs.'''
    #print(f'templates called, subpath={subpath}, {request}, returning templates/{subpath}')
    return send_from_directory('templates', subpath)

@app.route('/config/', methods=['GET', 'POST'])
def config():
    '''Handle generation of custom client configuration.'''
    if request.method == 'POST':
        #print(f'request.form: {request.form}')
        params = {
            'random_password': secrets.token_urlsafe(16),
            'date': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        }
        params['call'] = request.form['call'].upper()
        params['location'] = request.form['location']
        params['destcell'] = request.form['destcell']
        params['latitude'] = request.form['latitude']
        params['longitude'] = request.form['longitude']
        params['admin_password'] = request.form['admin_password']
        params['ethernet_config'] = request.form['ethernet_config']
        #print(f'params={params}')

        if not valid_string(valid_call_re, params['call']):
            flash('Call is required!')
        elif not valid_string(valid_location_re, params['location']):
            flash('Location is required!')
        elif not valid_string(valid_location_re, params['destcell']):
            flash('Destination cell is required!')
        elif not valid_float(params['latitude'], -90.0, 90.0):
            flash('Latitude is required and must be in the range -90.0 to 90.0')
        elif not valid_float(params['longitude'], -180.0, 180.0):
            flash('Longitude is required and must be in the range -180.0 to 180.0')
        elif not valid_string(valid_password_re, params['admin_password']):
            flash('A valid admin password is required!')
        elif not valid_string(valid_ethernet_config_re, params['ethernet_config']):
            flash('Ethernet configuration choice is required!')
        else:
            if request.form['submit'] == 'download':
                # Handle generation of custom client configuration file for download.
                byte_file = BytesIO()
                byte_file.write(render_template('config_template.rsc', params=params).encode('utf-8'))
                byte_file.seek(0)
                return send_file(byte_file, download_name=f"{params['call']}.rsc", as_attachment=True)
            return render_template('config_template.html', params=params)

    default_password = secrets.token_urlsafe(8)
    return render_template('config_form.html', default_password=default_password)
