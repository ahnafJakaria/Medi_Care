from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin, LoginManager, login_user, logout_user
from flask_login import login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from functools import wraps

app = Flask(__name__)
app.secret_key = 'hmsprojects_2024'

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/hospital_management'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

login_manager = LoginManager(app)
login_manager.login_view = 'login'


@login_manager.user_loader
def load_user(user_id):
    return Users.query.get(int(user_id))


# ─── Role Decorators ─────────────────────────────────────────────────────────

def doctor_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not current_user.is_authenticated or current_user.usertype != 'Doctor':
            flash('Access restricted to Doctors only.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated


def patient_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not current_user.is_authenticated or current_user.usertype != 'Patient':
            flash('Access restricted to Patients only.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated


# ─── Models ──────────────────────────────────────────────────────────────────

class Departments(db.Model):
    __tablename__ = 'departments'
    dept_id   = db.Column(db.Integer, primary_key=True)
    dept_name = db.Column(db.String(100), unique=True, nullable=False)


class Doctors(db.Model):
    __tablename__ = 'doctors'
    did        = db.Column(db.Integer, primary_key=True)
    email      = db.Column(db.String(50), unique=True, nullable=False)
    doctorname = db.Column(db.String(50), nullable=False)
    dept_id    = db.Column(db.Integer, db.ForeignKey('departments.dept_id'), nullable=False)
    department = db.relationship('Departments', backref='doctors')


class Diseases(db.Model):
    __tablename__ = 'diseases'
    disease_id   = db.Column(db.Integer, primary_key=True)
    disease_name = db.Column(db.String(100), unique=True, nullable=False)


class Patients(db.Model):
    __tablename__ = 'patients'
    pid    = db.Column(db.Integer, primary_key=True)
    email  = db.Column(db.String(50), unique=True, nullable=False)
    name   = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(20), nullable=False)
    number = db.Column(db.String(14), nullable=False)


class Appointments(db.Model):
    __tablename__ = 'appointments'
    appointment_id   = db.Column(db.Integer, primary_key=True)
    pid              = db.Column(db.Integer, db.ForeignKey('patients.pid'), nullable=False)
    did              = db.Column(db.Integer, db.ForeignKey('doctors.did'), nullable=False)
    disease_id       = db.Column(db.Integer, db.ForeignKey('diseases.disease_id'), nullable=False)
    slot             = db.Column(db.String(20), nullable=False)
    appointment_time = db.Column(db.Time, nullable=False)
    appointment_date = db.Column(db.Date, nullable=False)
    patient          = db.relationship('Patients', backref='appointments')
    doctor           = db.relationship('Doctors',  backref='appointments')
    disease          = db.relationship('Diseases', backref='appointments')


class Audit(db.Model):
    __tablename__ = 'audit'
    tid       = db.Column(db.Integer, primary_key=True)
    pid       = db.Column(db.Integer, db.ForeignKey('patients.pid'), nullable=False)
    action    = db.Column(db.String(50), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)


class Users(UserMixin, db.Model):
    __tablename__ = 'users'
    id       = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False)
    usertype = db.Column(db.String(50), nullable=False)
    email    = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(1000), nullable=False)


# ─── Routes ──────────────────────────────────────────────────────────────────

@app.route('/')
def index():
    doctors = Doctors.query.all()
    return render_template('index.html', doctors=doctors)


# ── Auth ──────────────────────────────────────────────────────────────────────

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    departments = Departments.query.all()

    if request.method == 'POST':
        username = request.form.get('username')
        usertype = request.form.get('usertype')
        email    = request.form.get('email')
        password = request.form.get('password')

        if Users.query.filter_by(email=email).first():
            flash('Email already registered.', 'warning')
            return redirect('/signup')

        new_user = Users(
            username=username,
            usertype=usertype,
            email=email,
            password=generate_password_hash(password)
        )
        db.session.add(new_user)

        if usertype == 'Doctor':
            dept_id = request.form.get('dept_id', 1)
            new_doctor = Doctors(
                email=email,
                doctorname=username,
                dept_id=dept_id
            )
            db.session.add(new_doctor)

        db.session.commit()
        flash('Account created! Please log in.', 'success')
        return redirect('/login')

    return render_template('signup.html', departments=departments)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email    = request.form.get('email')
        password = request.form.get('password')
        user     = Users.query.filter_by(email=email).first()

        if user and check_password_hash(user.password, password):
            login_user(user)
            flash(f'Welcome back, {user.username}!', 'success')
            if user.usertype == 'Doctor':
                return redirect(url_for('doctor_dashboard'))
            else:
                return redirect(url_for('patient_dashboard'))
        else:
            flash('Invalid email or password.', 'danger')

    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))


# ── Patient Routes ─────────────────────────────────────────────────────────────

@app.route('/patient/dashboard')
@login_required
@patient_required
def patient_dashboard():
    patient = Patients.query.filter_by(email=current_user.email).first()
    appointments = []
    if patient:
        appointments = Appointments.query.filter_by(pid=patient.pid).all()
    doctors = Doctors.query.all()
    return render_template('patient_dashboard.html',
                           appointments=appointments,
                           doctors=doctors,
                           patient=patient)


@app.route('/patient/book', methods=['GET', 'POST'])
@login_required
@patient_required
def book_appointment():
    doctors  = Doctors.query.all()
    diseases = Diseases.query.all()

    if request.method == 'POST':
        email  = request.form.get('email')
        name   = request.form.get('name')
        gender = request.form.get('gender')
        number = request.form.get('number')

        did        = request.form.get('did')
        disease_id = request.form.get('disease_id')
        slot       = request.form.get('slot')
        appt_time  = request.form.get('time')
        appt_date  = request.form.get('date')

        if len(number) != 11:
            flash('Phone number must be exactly 11 digits.', 'danger')
            return redirect('/patient/book')

        patient = Patients.query.filter_by(email=email).first()
        if not patient:
            patient = Patients(email=email, name=name, gender=gender, number=number)
            db.session.add(patient)
            db.session.commit()

        appointment = Appointments(
            pid=patient.pid, did=did, disease_id=disease_id,
            slot=slot, appointment_time=appt_time, appointment_date=appt_date
        )
        db.session.add(appointment)
        db.session.commit()
        flash('Appointment booked successfully!', 'success')
        return redirect(url_for('patient_dashboard'))

    return render_template('book_appointment.html', doctors=doctors, diseases=diseases)


@app.route('/patient/edit/<int:id>', methods=['GET', 'POST'])
@login_required
@patient_required
def edit_appointment(id):
    appointment = Appointments.query.get_or_404(id)

    patient = Patients.query.filter_by(email=current_user.email).first()
    if not patient or appointment.pid != patient.pid:
        flash('You cannot edit this appointment.', 'danger')
        return redirect(url_for('patient_dashboard'))

    doctors  = Doctors.query.all()
    diseases = Diseases.query.all()

    if request.method == 'POST':
        appointment.did              = request.form.get('did')
        appointment.disease_id       = request.form.get('disease_id')
        appointment.slot             = request.form.get('slot')
        appointment.appointment_time = request.form.get('time')
        appointment.appointment_date = request.form.get('date')
        db.session.commit()
        flash('Appointment updated!', 'success')
        return redirect(url_for('patient_dashboard'))

    return render_template('edit_appointment.html',
                           appointment=appointment,
                           doctors=doctors,
                           diseases=diseases)


@app.route('/patient/delete/<int:id>')
@login_required
@patient_required
def delete_appointment(id):
    appointment = Appointments.query.get_or_404(id)
    patient = Patients.query.filter_by(email=current_user.email).first()
    if not patient or appointment.pid != patient.pid:
        flash('You cannot delete this appointment.', 'danger')
        return redirect(url_for('patient_dashboard'))

    db.session.delete(appointment)
    db.session.commit()
    flash('Appointment cancelled.', 'warning')
    return redirect(url_for('patient_dashboard'))


@app.route('/doctors/list')
def doctors_list():
    departments = Departments.query.all()
    dept_filter = request.args.get('dept')
    if dept_filter:
        doctors = Doctors.query.filter_by(dept_id=dept_filter).all()
    else:
        doctors = Doctors.query.all()
    return render_template('doctors_list.html', doctors=doctors, departments=departments, selected=dept_filter)


# ── Doctor Routes ──────────────────────────────────────────────────────────────

@app.route('/doctor/dashboard')
@login_required
@doctor_required
def doctor_dashboard():
    doctor = Doctors.query.filter_by(email=current_user.email).first()
    if doctor:
        appointments = Appointments.query.filter_by(did=doctor.did).all()
    else:
        appointments = Appointments.query.all()

    total_patients = Patients.query.count()
    total_appts    = Appointments.query.count()
    return render_template('doctor_dashboard.html',
                           appointments=appointments,
                           total_patients=total_patients,
                           total_appts=total_appts,
                           doctor=doctor)


@app.route('/doctor/all-appointments')
@login_required
@doctor_required
def all_appointments():
    appointments = Appointments.query.all()
    return render_template('all_appointments.html', appointments=appointments)


@app.route('/doctor/audit')
@login_required
@doctor_required
def audit_logs():
    logs = Audit.query.order_by(Audit.timestamp.desc()).all()
    return render_template('audit_logs.html', logs=logs)


# ── Utility ───────────────────────────────────────────────────────────────────

@app.route('/test')
def test():
    try:
        Patients.query.all()
        return 'Database connected successfully!'
    except Exception as e:
        return f'Database error: {e}'


if __name__ == '__main__':
    app.run(debug=True)
